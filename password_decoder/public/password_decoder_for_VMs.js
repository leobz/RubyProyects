 function Main(){

        var uuid= document.getElementById('uuid').value;
        var challenge_code= document.getElementById('challenge_code').value; 
        var checkBox = document.getElementById("checkExpertPassword");
        var text = document.getElementById("challenge_code");
        var challenge_code_label = document.getElementById("challenge_code_label");
        var type_password =  defineTypePassword(checkBox);

              function defineTypePassword(){
                  if (checkBox.checked ){
                    return "ExpertPassword";
                  }
                  return "RootPassword";
              }

              function validateUuid(){
                    if(uuid == "" ){ 
                      alert('Please, input the uuid');
                      return false;
                    }
                    if (uuid.length != 36){
                     alert('The uuid must be of 36 characters')
                      return false
                    }
                    return true; 
              }     
                        
              function validateChallengeCode(){
                  if(challenge_code == "" && checkBox.checked){ 
                    alert('Please, input the challenge code');
                    return false;
                  }
                  if (challenge_code.length != 4 && checkBox.checked){
                     alert('The Challenge Code must be of 4 characters')
                      return false
                  }
                  return true; 
              }     

            
               

              this.expertPasswordEnabled = function() {
                  if (checkBox.checked){
                    text.style.display = "block";
                    challenge_code_label.style.display = "block";
                    return
                  } 
                  text.style.display = "none";
                  challenge_code_label.style.display = "none";
              }

              this.sendData = function (){
                  
                  $.ajax({
                    type: "post",
                    url: "/answer",
                    data:{ uuid: uuid , challenge_code: challenge_code, type_password: type_password},
                    success: function(response) {
                       if (validateUuid() && validateChallengeCode()){
                        $('#response_label').html(response);
                      }       
                    }
                  });
                  return false
              }
  }           