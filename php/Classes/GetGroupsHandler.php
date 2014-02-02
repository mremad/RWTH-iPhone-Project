<?php

class GetGroupsHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		
		$groups = array();
		if ($userID > 0)
		{
			
			$query = "SELECT groupID FROM groupusers WHERE userID = $userID AND accepted = 1";
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				while ($row = $res->fetch_assoc()) 
				{
					$groupName = $this->getGroupName($row["groupID"]); 
					if ($groupName)
						$groups[] = array("groupID" => $row["groupID"], "groupname" => $groupName);
				}
			}
			 
		}
		return array("groups"=> $groups);
	}
	
}


?>