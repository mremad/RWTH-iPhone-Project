<?php

class RejectInvitationHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
		
		if ($userID && $groupID)
		{
			$query = "DELETE FROM groupusers  WHERE userID = $userID AND groupID = $groupID AND accepted = 0 LIMIT 1";
			$res = $this->mysqli->query($query);
			if ($res)
				return array("response" => "success");
		}
		
		return array("response" => "failure");
	}
	
}


?>