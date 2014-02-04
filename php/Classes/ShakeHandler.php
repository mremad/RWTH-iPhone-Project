<?php

define('RADIUS', 0.01);
define('TIMEWINDOW', 50); // in seconds

class ShakeHandler extends ActionHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$latitude = (float)$this->mysqli->real_escape_string($this->options["latitude"]);
		$longitude = (float)$this->mysqli->real_escape_string($this->options["longitude"]);
		$timestamp = time();
		if ($userID > 0)
		{
			$query = "SELECT groupID, longitude, latitude FROM shakes WHERE timestamp >= $timestamp - ".TIMEWINDOW." AND groupID > 0 AND userID != $userID";
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				$groupID = 0;
				while ($row = $res->fetch_assoc()) 
				{
					if (abs($latitude - (float)$row['latitude']) < RADIUS && abs($longitude - (float)$row['longitude']) < RADIUS)
					{
						$groupID = $row['groupID'];
					}
				}
				
				if ($groupID > 0)
				{
					$query = "INSERT INTO groupusers (groupID, userID,accepted) VALUES ($groupID, $userID,1)";
					$res = $this->mysqli->query($query);
				}
				else
				{
					$handler = new AddGroupHandler(array("username" => $this->options["username"], "groupname" => "New Group"));
					$data = $handler->trigger();
					$groupID = $data["groupID"];
				}
				
				$query = "INSERT INTO shakes (userID, latitude, longitude, timestamp, groupID) VALUES ($userID, '$latitude', '$longitude', '$timestamp', $groupID)";
				$res = $this->mysqli->query($query);
				if ($res)
					return array("response" => "success");
			}					
		}
		return array("response" => "failure");
	}
	
}


?>