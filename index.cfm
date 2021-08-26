<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sample Code</title>
    <style>
        .container {
            position: relative;
            text-align: center;
            color: white;
            font-size: 18px;
        }
        
        .centered {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }
    </style>
   
    <script>
        function fncScrollWindow() {
            window.scroll(0, 250);
        }
        function fncLoadSampleCode () {
            window.open('apps/evaluation/index.cfm', '_blank');
        }
        function fncLoadQuizTest () {
            window.open('apps/evaluation/quiztest.cfm', '_blank');
        }
    </script>
</head>
<body onload="fncScrollWindow()">
    <div class="container">
      <img src="images/landscape.jpg" alt="Interview" style="width:100%;">
      <div class="centered" >
        <p onclick="fncLoadSampleCode();">Evaluation Form</p>
        <!--- <p onclick="fncLoadQuizTest();">test quiz</p> --->
    </div>
</div>
</body>
</html>
