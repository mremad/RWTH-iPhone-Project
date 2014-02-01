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
	protected function isUserGroupOwner($username, $groupID)
	{
		$userID = $this->getUserIDIfExists($username);
		if ($userID > 0)
		{
			$query = "SELECT ownerID FROM groups WHERE ownerID = $userID AND ID = $groupID LIMIT 1";
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
	
	protected function getGroupUsers($groupID)
	{
		$users = array();
		$groupID = $this->getGroupIDIfExists($groupID);
		if ($groupID > 0)
		{
			$query = "SELECT userID FROM groupusers WHERE groupID = $groupID";
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				while ($row = $res->fetch_assoc()) 
				{
					$users[] = $row["userID"];
				}
			}
		}
		return $users;
	}
}


?>