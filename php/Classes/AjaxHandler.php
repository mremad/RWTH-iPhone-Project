<?php
error_reporting(E_ERROR | E_PARSE);

class AjaxHandler
{
  	/*
    	Class for handling ajax and printing results in JSON format
  	*/
	public function __construct()
  	{
		header("Cache-Control: no-cache");
		header('Content-type: application/json');
	
		if ($_SERVER['REQUEST_METHOD'] === 'POST')
		{
			$this->actionHandler = $_POST["action"];
			$this->options = $_POST;
			unset($this->options["action"]);
		}
		else if ($_SERVER['REQUEST_METHOD'] === 'GET')
		{
			$this->actionHandler = $_GET["action"];
			$this->options = $_GET;
			unset($this->options["action"]);
		}
		else
			die();
		echo $this->getJSONData();
		// Make sure that nothing else gets evaluated after this method.
		die();
  	}
	public function getJSONData()
  	{   
		$class = $this->actionHandler."Handler";
    	if (class_exists($class) && is_subclass_of($class, "ActionHandler"))
    	{
			$obj = new $class($this->options);
			// Trigger the action.
        	$data = $obj->trigger();
        	if (!empty($data)) // Return json data if not empty
          		return json_encode($data);
    	}
		return json_encode(array());
	}
}



?>