<?php

class SetAppointmentHandler extends GroupHandler
{
	public function trigger()
	{	
		// Escape string for protecting against injection.
		$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
		$start = $this->options["start"];
		$end = $this->options["end"];
		if ($groupID > 0 && $start && $end)
		{
			$query = "INSERT INTO appointments (groupID, start, end) VALUES ($groupID, $start, $end)";
			$res = $this->mysqli->query($query);
			return array("response" => "success");
		}
		return array("response" => "failure");
	}
}


?>