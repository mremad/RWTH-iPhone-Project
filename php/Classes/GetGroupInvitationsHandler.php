<?php

class GetGroupInvitationsHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		
		$invites = array();
		if ($userID > 0)
		{
			
			$query = "SELECT groupID FROM groupusers WHERE userID = $userID AND accepted = 0";
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				while ($row = $res->fetch_assoc()) 
				{
					$groupName = $this->getGroupName($row["groupID"]); 
					if ($groupName)
						$invites[] = array("groupID" => $row["groupID"], "groupName" => $groupName);
				}
			}
			 
		}
		return array("invites"=> $invites);
	}
	
}


?>