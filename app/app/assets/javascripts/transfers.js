jQuery(function() {
  var bitrate, clip, multiple_transfers_form, progress_bar, wrapper;
  clip = new Clipboard('.btn-clip');
  console.log(clip);
  multiple_transfers_form = $('#new_transfer');
  multiple_transfers_form.fileupload({
    dataType: 'script',
    maxFileSize: gon.maximum_file_size,
    add: function(e, data) {
      var file;
      file = data.files[0];
      if (file.size < gon.maximum_file_size) {
        return data.submit();
      } else {
        return alert(file.name + " is is too big");
      }
    }
  });
  wrapper = $('#progress-wrapper');
  progress_bar = wrapper.find('.progress-bar');
  bitrate = wrapper.find('.bitrate');
  multiple_transfers_form.on('fileuploaddone', function() {
    progress_bar.width(0);
  });
  multiple_transfers_form.on('fileuploadprogressall', function(e, data) {
    var progress;
    progress = parseInt(data.loaded / data.total * 100, 10);
    progress_bar.css('width', progress + '%').text;
  });
  multiple_transfers_form.on('processfail', function(e, data) {
    return alert('Error uploading');
  });
});