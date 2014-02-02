<?php

class SetBusyHandler extends ActionHandler
{
	public function trigger()
	{	
		// Escape string for protecting against injection.
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$start = $this->options["start"];
		$end = $this->options["end"];
		if ($userID > 0 && $start && $end && $start < $end)
		{
			$query = "DELETE FROM schedules WHERE userID = $userID AND start >= $start AND end <= $end";
			$res = $this->mysqli->query($query);
			$query = "INSERT INTO schedules (userID, start, end) VALUES ($userID, $start, $end)";
			$res = $this->mysqli->query($query);
			return array("response" => "success");
		}
		return array("response" => "failure");
	}
}


?>