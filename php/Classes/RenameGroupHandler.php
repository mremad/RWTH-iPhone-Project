<?php

class RenameGroupHandler extends GroupHandler
{
	public function trigger()
	{	
		$groupname = $this->mysqli->real_escape_string($this->options["groupname"]);
		$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
		
		if ($groupname)
		{		
			$query = "UPDATE groups SET groupname = '$groupname' WHERE ID = $groupID LIMIT 1";
			$res = $this->mysqli->query($query);
			if (!$res)
			{
				return array("query '$query' has errors!");
			}
			
			return array("response" => "success");
		}
		else if (!$groupname)
		{
			return array("response" => "groupname is missing!");
		}
	}
}


?>