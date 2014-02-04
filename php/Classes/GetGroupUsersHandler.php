<?php

class GetGroupUsersHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
		
		$users = array();
		if ($userID > 0 && $groupID)
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
		}
		return array("users"=> $users);
	}
	
}


?>