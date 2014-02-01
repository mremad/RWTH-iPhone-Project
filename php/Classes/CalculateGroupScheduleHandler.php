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
							$groupSchedule[$i] = 3;
						else if ($busy)
							$groupSchedule[$i] = 1;
						else if ($userAvailable)
							$groupSchedule[$i] = 2;	
						else
							$groupSchedule[$i] = 0;
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