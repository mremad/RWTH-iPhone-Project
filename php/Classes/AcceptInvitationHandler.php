<?php

class AcceptInvitationHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
		
		if ($userID && $groupID)
		{
			$query = "UPDATE groupusers SET accepted = 1  WHERE userID = $userID AND groupID = $groupID LIMIT 1";
			$res = $this->mysqli->query($query);
			if ($res)
				return array("response" => "success");
		}
		
		return array("response" => "failure");
	}
	
}


?>