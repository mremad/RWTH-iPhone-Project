<?php

class GroupHandler extends ActionHandler
{
	protected function getGroupIDIfExists($groupID)
	{
		if ($groupID <= 0)
			return 0;
		$query = "SELECT ID FROM groups WHERE ID = $groupID LIMIT 1";
		$res = $this->mysqli->query($query);
		if ($res)
		{
			$res->data_seek(0);
			while ($row = $res->fetch_assoc()) 
			{
				return $row["ID"];
			}
		}
		return 0;
	}
	protected function isUserInGroup($username, $groupID)
	{
		$userID = $this->getUserIDIfExists($this->options["username"]);
		if ($userID > 0)
		{
			$query = "SELECT userID FROM groupusers WHERE groupID = $groupID AND userID = $userID LIMIT 1";
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