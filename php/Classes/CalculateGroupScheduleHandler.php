<?php

class CalculateGroupScheduleHandler extends GroupHandler
{
	public function trigger()
	{	
		if ($this->options["groupID"] > 0)
		{
			$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
			$start = $this->options["start"];
			$end = $this->options["end"];
			
			if ($groupID)
			{
				$groupUsers = $this->getGroupUsers($groupID);
				
				$availability = array();
				
				$groupSchedule = array();
				
				if (!empty($groupUsers))
				{
					$minTime = null;
					$maxTime = 0;
					foreach($groupUsers as $userID)
					{
						$availability[$userID] = $this->getUserAvailability($userID, $start, $end);
						
						if (empty($availability[$userID]))
							continue;
						
						$lastkey = end(array_keys($availability[$userID]));
						
						reset($availability[$userID]);
						$firstkey = key($availability[$userID]);
						
						if (!$minTime)
							$minTime = $firstkey;
						
						if ($lastkey > $maxTime)
							$maxTime = $lastkey;
						if ($firstkey < $minTime)
							$minTime = $firstkey;
					}

					$states = array("available","busy", "appointment_fixed");
					
					$counter = 0;
					for ($i=$minTime; $i <=$maxTime; $i++)
					{
						if ($i == 0 || $i == null || $i< $start || $i > $end)
							continue;
							
							
						$busy = false;
						
						foreach($groupUsers as $userID)
						{
							$busy = $busy || $availability[$userID][$i];
						}
						$userAvailable = !$availability[$thisUserID][$i];
						
						$appointmentMade = $this->isGroupAppointmentMadeAtInterval($groupID, $i);
						
						if ($appointmentMade)
							$state = 2;
						else if ($busy)
							$state = 1;
						else
							$state = 0;

						if ($state > 0)
						{
							$groupSchedule[$counter]["start"] = date("Y-m-d H:i:s", $i * TIME_INTERVAL);
							$groupSchedule[$counter]["end"] = date("Y-m-d H:i:s", ($i+1) * TIME_INTERVAL - 1);
							$groupSchedule[$counter]["state"] = $states[$state];
						}
						
						$counter++;	
							
					}
					
					return array("response" => $groupSchedule);
					
				}
			}
		}	
	}
	
	private function getUserAvailability($userID, $start, $end)
	{
		$availability = array();
		//$userID = $this->getUserIDIfExists($userID);
		if ($userID > 0)
		{
			$query = "SELECT start, end FROM schedules WHERE userID = $userID AND start >= $start OR end <= $end";
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				while ($row = $res->fetch_assoc()) 
				{
					//$availability[] = (bool)$row["state"];
					$start = (int)$row["start"] / TIME_INTERVAL;
					$end = (int)$row["end"] / TIME_INTERVAL;
					
					for($i=$start; $i<= $end; $i++)
					{
						$availability[$i] = true;
					}
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
			$start = $timeInterval * TIME_INTERVAL;
			$end = ($timeInterval+1) * TIME_INTERVAL - 1;
			$query = "SELECT start FROM appointments WHERE groupID = $groupID AND start <= $start AND end >= $end";
			
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				while ($row = $res->fetch_assoc()) 
				{
					//$start = (int)$row["start"] / TIME_INTERVAL;
					//$end = (int)$row["end"] / TIME_INTERVAL;
					
					//if ($timeInterval >= $start && $timeInterval<= $end)
						return true;
				}
			}
		}
		return false;
	}
	
}


?>