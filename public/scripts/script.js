$(function(){

    $('.alert').hide();

    $('#target').submit(getURL);
    var id = 0;



    function getURL(event) {
        event.preventDefault();
        $('.alert').hide();
        $('#submit-btn').button('loading');
        var urlField = $('#url');
        var url = urlField.val();
        $('.preload').css("display", "block");
        $.ajax({
            method: 'GET',
            url: '/cms-detect',
            data: {
                url: url
            }
        }).
        success(function(data){


            data = JSON.parse(data);

            var html = $('#result').find('tbody').html();
            id += 1;
            $('#result').find('tbody').html(html+
                '<tr>\n' +
                    '<td>#' + id +'</td>\n' +
                    '<td>'+ data.site +'</td>\n' +
                    '<td>' + data.status +'</td>\n' +
                    '<td>' + data.html + '</td>\n' +
                '</tr>');
            $('#submit-btn').button('reset');

        }).error(function(){

            $('.alert').show();
            $('#submit-btn').button('reset');
            console.log('ERROR');

        });
        urlField.val('');
    }

});