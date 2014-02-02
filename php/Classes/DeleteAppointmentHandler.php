<?php

class DeleteAppointmentHandler extends GroupHandler
{
	public function trigger()
	{	
		$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
		$start = $this->options["start"];
		$end = $this->options["end"];
		if ($groupID > 0 && $start && $end)
		{
			$query = "DELETE FROM appointments WHERE groupID = $groupID AND start = $start AND end = $end LIMIT 1";
			$res = $this->mysqli->query($query);
			return array("response" => "success");
		}
		return array("response" => "failure");
	}
}


?>