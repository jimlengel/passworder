$(document).ready(function() {
  $("form input:lt(1)").focus();
  showStudent();

});

function showStudent(){
  $('.student-table').on('click', '#detail', function(e){
    e.preventDefault();
    var deleteUrl = $(this).parent().attr('action');
    
    // alert(deleteUrl);

    var request = $.ajax({
      url: deleteUrl,
      method: 'get'
      })

    request.done(function(res){
      // console.log(res);
      $("#detail-area").html(res);




      // $('#post-list').prepend(res);
      // $('#new-post-form').find("input[type=text], textarea").val("");
    })

    // request.fail(function(res){
    //   console.log("Something failed. The comment was not posted.")
    // })

  });
};