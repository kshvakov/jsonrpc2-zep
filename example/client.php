<?php 

class Discovery implements \JsonRPC2\Discovery{

	public function Get() {


	}
}


$client = new \JsonRPC2\Client(new Discovery());