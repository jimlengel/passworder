$(document).ready(function() {
  $("form input:lt(1)").focus();
  showStudent();

});

function showStudent(){
  $('.student-table').on('click', '#delete', function(e){
    e.preventDefault();
    alert('hi');
    var deleteUrl = $('#delete-form').attr('action');
    alert(deleteUrl);

    var request = $.ajax({
      url: deleteUrl,
      method: 'delete'
      })

    request.done(function(res){
      // console.log(res);
      $('#post-list').prepend(res);
      $('#new-post-form').find("input[type=text], textarea").val("");
    })

    // request.fail(function(res){
    //   console.log("Something failed. The comment was not posted.")
    // })

  });
};