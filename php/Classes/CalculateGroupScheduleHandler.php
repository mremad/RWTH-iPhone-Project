<?php

class CalculateGroupScheduleHandler extends GroupHandler
{
	public function trigger()
	{	
		if ($this->options["groupID"] > 0)
		{
			$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
			$thisUserID = $this->getUserIDIfExists($this->options["username"]);
			
			if ($groupID && $thisUserID)
			{
				$groupUsers = $this->getGroupUsers($this->options["groupID"]);
				
				$availability = array();
				
				$groupSchedule = array();
				
				if (!empty($groupUsers))
				{
					foreach($groupUsers as $userID)
					{
						$availability[$userID] = $this->getUserAvailability($userID);
					}
					
					$days = array("Monday", "Tuesday", "Wednesday", "Thursday", "Friday");
					$states = array("available", "busy", "user_available", "appointment_fixed");
					for ($i=0; $i <TOTAL_INTERVALS; $i++)
					{
						$busy = false;
						
						foreach($groupUsers as $userID)
						{
							$busy = $busy || $availability[$userID][$i];
						}
						$userAvailable = !$availability[$thisUserID][$i];
						
						$appointmentMade = $this->isGroupAppointmentMadeAtInterval($groupID, $i);
						
						if ($appointmentMade)
							$state = 3;
						else if ($busy)
							$state = 1;
						else if ($userAvailable)
							$state = 2;	
						else
							$state = 0;
							
							
						$day = $days[floor($i / 24)];
						$hour = $i % 24;
						$groupSchedule[$i]["interval"] = "$day $hour".":00 - $hour".":59";
						$groupSchedule[$i]["state"] = $states[$state];	
							
					}
					
					return array("response" => $groupSchedule);
					
				}
			}
		}	
	}
	
	private function getUserAvailability($userID)
	{
		$availability = array();
		//$userID = $this->getUserIDIfExists($userID);
		if ($userID > 0)
		{
			$query = "SELECT state FROM schedules WHERE userID = $userID";
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				while ($row = $res->fetch_assoc()) 
				{
					$availability[] = (bool)$row["state"];
				}
			}
		}
		return $availability;
	}
	
	private function isGroupAppointmentMadeAtInterval($groupID, $timeInterval)
	{
		$groupID = $this->getGroupIDIfExists($groupID);
		if ($groupID > 0)
		{
			$query = "SELECT timeInterval FROM appointments WHERE groupID = $groupID AND timeInterval = $timeInterval";
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				while ($row = $res->fetch_assoc()) 
				{
					return true;
				}
			}
		}
		return false;
	}
	
}


?>