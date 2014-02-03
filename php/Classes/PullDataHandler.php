<?php

class PullDataHandler extends GroupHandler
{
	public function trigger()
	{	
		if ($this->options["getShakeInfo"])
			return array("shakeInfo" => $this->getShakeInfo());
		else
			return array("invites" => $this->getInvitations(), "appointments" => $this->getAppointments());
	}
	
	private function getInvitations()
	{
		$handler = new GetGroupInvitationsHandler(array("username" => $this->options["username"]));
		$data = $handler->trigger();
		if (empty($data))
			return array();
		return $data["invites"];
	}
	
	private function getAppointments()
	{
		$userID = $this->getUserIDIfExists($this->options["username"]);
		if ($userID > 0)
		{
			$appointments = array();
		
			$query = "SELECT appointments.start, appointments.end, groupusers.groupID FROM appointments INNER JOIN groupusers ON appointments.groupID = groupusers.groupID WHERE groupusers.userID = $userID AND groupusers.accepted = 1";
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				while ($row = $res->fetch_assoc()) 
				{
					$groupName = $this->getGroupName($row["groupID"]); 
					if ($groupName)
						$appointments[] = array("groupID" => $row["groupID"], "groupname" => $groupName, "start" => $row["start"], "end" => $row["end"]);
				}
			}
			 
		}
		return $appointments;
	}
	
	private function getShakeInfo()
	{
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$query = "SELECT groupID FROM shakes WHERE userID = $userID AND timestamp >= UNIX_TIMESTAMP() - 15 ORDER BY timestamp DESC LIMIT 1";
		$res = $this->mysqli->query($query);
		if ($res)
		{
			$res->data_seek(0);
			while ($row = $res->fetch_assoc()) 
			{
				$groupName = $this->getGroupName($row["groupID"]); 
				if ($groupName)
					return array("groupID" => $row["groupID"], "groupname" => $groupName);
			}
		}
		
		return array();
	}
}


?>