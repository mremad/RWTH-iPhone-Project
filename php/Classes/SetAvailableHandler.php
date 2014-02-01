<?php

class SetAvailableHandler extends ActionHandler
{
	public function trigger()
	{	
		// Escape string for protecting against injection.
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$timeInterval = $this->options["timeInterval"];
		if ($userID > 0 && $timeInterval)
		{
			$query = "UPDATE schedules SET state = '0' WHERE  userID = $userID AND  timeInterval = $timeInterval LIMIT 1";
			$res = $this->mysqli->query($query);
		return array("response" => "success");
		}
		return array("response" => "failure");
	}
}


?>