module FileAssetsHelper
  
  def video_player(content)
    javascript_tag %Q<
      flowplayer('player_#{content.id}', '/swf/flowplayer.swf', {
        clip: {
          autoPlay: false
        },
        plugins: { 
            controls: { 
                url: 'flowplayer.controls.swf', 
                bottom:0, 
                height:24, 
                backgroundColor: '#bbbbbb', 
                backgroundGradient: 'none',
                timeColor: '#ffffff',
                buttonColor: '#222222'
            }
        }
        
      });
    >
  end
end
