<?php

class ShakeHandler extends ActionHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$latitude = $this->mysqli->real_escape_string($this->options["latitude"]);
		$longitude = $this->mysqli->real_escape_string($this->options["longitude"]);
		$timestamp = $this->mysqli->real_escape_string($this->options["timestamp"]);
		if ($userID > 0)
		{
			$query = "INSERT INTO shakes (userID, latitude, longitude, timestamp) VALUES ($userID, '$latitude', '$longitude', '$timestamp')";
			$res = $this->mysqli->query($query);
		}
	}
}


?>