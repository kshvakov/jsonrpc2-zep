namespace JsonRPC2;

class Client {

	protected _balancer;

	public function __construct(<Balancer> balancer) {

		let this->_balancer = balancer;
	}

	public function Send(string method, <Params> params, <Result> result) -> <Err> {

		var counter,
			request,
			err;

		let counter = this->_balancer->Len(),
			request = json_encode([
				"id"      : rand(1, 5000),
				"method"  : method,
				"params"  : params->Get(),
				"jsonrpc" : "2.0"
			]
		);

		while counter {

			let err = this->_send(request, result);

			if err instanceof \JsonRPC2\NillError {

				return new NillError(); 
			} 

			if err instanceof \JsonRPC2\LogicError {

				return err;
			}

			let counter--;
		}

		return err;
	}

	protected function _send(string data, <Result> result) -> <Err> {

		var curl,
			response,
			httpCode,
			error        = [],
			responseData = [];

		let curl = curl_init();

		curl_setopt_array(
			curl, [
				CURLOPT_URL            : this->_balancer->Get(),
				CURLOPT_TIMEOUT        : 10,
				CURLOPT_POST           : true,
				CURLOPT_POSTFIELDS     : data,
				CURLOPT_RETURNTRANSFER : true
			]
		);

		let response = curl_exec(curl),
			httpCode = curl_getinfo(curl, CURLINFO_HTTP_CODE);

		curl_close(curl);

		if httpCode != 200 {

			return new TransportError(sprintf("http code: %d", httpCode));
		}

		let responseData = json_decode(response, true);

		if JSON_ERROR_NONE != json_last_error() {

			return new Error("Parse Error");
		}

		if fetch error, responseData["error"] {

			if error["code"] == Server::LogicErr {

				return new LogicError(error["message"]);
			}

			return new Error(error["message"]);
		}

		result->Set(responseData["result"]);

		return new NillError();
	}
}