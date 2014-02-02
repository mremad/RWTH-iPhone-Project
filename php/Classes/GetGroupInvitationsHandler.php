<?php

class GetGroupInvitationsHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		
		$invites = array();
		if ($userID > 0)
		{
			
			$query = "SELECT groupID, adderID FROM groupusers WHERE userID = $userID AND accepted = 0";
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				while ($row = $res->fetch_assoc()) 
				{
					$username = $this->getUsername($row["adderID"]);
					$nickname = $this->getNickname($row["adderID"]);
					$groupName = $this->getGroupName($row["groupID"]); 
					if ($groupName)
						$invites[] = array("groupID" => $row["groupID"], "groupname" => $groupName, "senderUsername" => $username, "senderNickname"=>$nickname);
				}
			}
			 
		}
		return array("invites"=> $invites);
	}
	
}


?>