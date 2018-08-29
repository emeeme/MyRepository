function openQRCamera(node) {
    var reader = new FileReader();
    reader.onload = function() {
        node.value = "";
        qrcode.callback = function(res) {
            if(res instanceof Error){
                alert("QRが読み込めませんでした。もう一度撮影してください。");
            } else {
                //node.parentNode.previousElementSibling.value = res;
                node.parentNode.nextElementSibling.value = res;

                var result = res.split(',');

                document.getElementById("reception_productno").value = result[0];
                document.getElementById("reception_lotno").value = result[1];
                document.getElementById("reception_producttype").value = result[2];
                document.getElementById("reception_steeltype").value = result[3];
                document.getElementById("reception_size").value = result[4];
                document.getElementById("reception_quantity").value = result[5];
            }
        };
        qrcode.decode(reader.result);
    };
    reader.readAsDataURL(node.files[0]);
}