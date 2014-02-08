<?php

class GetGroupUsersHandler extends GroupHandler
{
	public function trigger()
	{	
		//$userID = $this->getUserIDIfExists($this->options["username"]);
		$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
		
		$users = array();
		if ($groupID)
		{
			
			$query = "SELECT userID FROM groupusers WHERE groupID = $groupID AND accepted = 1";
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				while ($row = $res->fetch_assoc()) 
				{
					$username = $this->getUsername($row["userID"]);
					$nickname = $this->getNickname($row["userID"]);
					
					if ($username && $nickname)
						$users[] = array("userID" => $row["userID"], "username" => $username, "nickname" => $nickname);
					else if ($username)
						$users[] = array("userID" => $row["userID"], "username" => $username);
				}
			} 
			
			
			$query = "SELECT userID, adderID FROM groupusers WHERE groupID = $groupID AND accepted = 0";
			$res = $this->mysqli->query($query);
			if ($res)
			{
				$res->data_seek(0);
				while ($row = $res->fetch_assoc()) 
				{
					$username = $this->getUsername($row["userID"]);
					$nickname = $this->getNickname($row["userID"]);
					
					$adderusername = $this->getUsername($row["adderID"]);
					$addernickname = $this->getNickname($row["adderID"]);
					
					$userArray = array();
					$userArray["userID"] = $row["userID"];
					$userArray["username"] = $username;
					$userArray["nickname"] = $nickname;
					$userArray["inviterID"] = $row["userID"];
					$userArray["inviterUsername"] = $adderusername;
					$userArray["inviterNickname"] = $addernickname;
					
					$users[] = $userArray;
					

				}
			} 
			
		}
		return array("users"=> $users);
	}
	
}


?>