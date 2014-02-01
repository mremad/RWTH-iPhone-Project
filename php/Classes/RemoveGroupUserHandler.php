<?php

class RemoveGroupUserHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
		if ($userID > 0 && $groupID > 0)
		{
			$userAlreadyInGroup = $this->isUserInGroup($this->options["username"], $groupID);
			if ($userAlreadyInGroup)
			{	
				$query = "DELETE FROM groupusers WHERE userID = $userID AND groupID = $groupID LIMIT 1";
				$res = $this->mysqli->query($query);
				
				if ($this->isUserGroupOwner($this->options["username"], $groupID))
				{
					// Delete the group if user is the group owner.
					$query = "DELETE FROM groups WHERE ownerID = $userID LIMIT 1";
					$res = $this->mysqli->query($query);
					
					$query = "DELETE FROM groupusers WHERE groupID = $groupID";
					$res = $this->mysqli->query($query);
				}
				
				
				return array("response" => "success");
			}
			return array("response" => "user not in group");
		}
		return array("response" => "failure");
	}
}


?>