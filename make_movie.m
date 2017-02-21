function make_movie(angles,cent,bound,hd,head_angles)    
    writerObj = VideoWriter('worm.avi');
    writerObj.FrameRate = 10;
    writerObj.Quality = 100; 
    open(writerObj);
   
    ang = head_angles';

    [V, ~] = eig(cov(ang));

for i = 1:length(angles)
    amp2(1,i) = -ang(i,:) * V(:,end);
    amp2(2,i) = -ang(i,:) * V(:,end-1);
    amp2(3,i) = -ang(i,:) * V(:,end-2);
    amp2(4,i) = ang(i,:) * V(:,end-3);
end
amp2(1,:) = amp2(1,:)/max(amp2(1,:));
amp2(2,:) = amp2(2,:)/max(amp2(2,:));
amp2(3,:) = amp2(3,:)/max(amp2(3,:));
amp2(4,:) = amp2(4,:)/max(amp2(4,:));
n = 100;

    for ii = 1:2:5000%length(angles)
        %% Process the image and get releavant properties           
        fprintf('processing image #%i\n',ii)

                h = figure; set(h, 'Visible', 'off'); hold on
                set(gca,'nextplot','replacechildren');
                set(h,'renderer','painters');
                
                subplot(4,4,[1,2,5,6,9,10,13,14]), hold on

                    plot(cent{ii}(:,1),cent{ii}(:,2),'r')
                    plot(bound{ii}(:,1),bound{ii}(:,2),'.k','MarkerSize',0.5)
                    plot(hd{ii}(:,2),hd{ii}(:,1),'.b','MarkerSize',20), axis equal, axis off

               subplot(4,4,3:4)
                   if ii>n
                        plot(amp2(1,ii-n:ii),'k')
                   else
                       plot(amp2(1,1:ii),'k')
                   end
                   ylim([-1.5,1.5])
              subplot(4,4,7:8) 
                   if ii>n
                        plot(amp2(2,ii-n:ii),'r')
                   else
                       plot(amp2(2,1:ii),'r')
                   end
                   ylim([-1.5,1.5])
              subplot(4,4,11:12), ylim([-1.5,1.5])
                   if ii>n
                        plot(amp2(3,ii-n:ii),'b')
                   else
                       plot(amp2(3,1:ii),'b')
                   end
                   ylim([-1.5,1.5])
              subplot(4,4,15:16)
                   if ii>n
                        plot(amp2(4,ii-n:ii),'g')
                   else
                       plot(amp2(4,1:ii),'g')
                   end
                   ylim([-1.5,1.5])
                   
                                                
            drawnow;
            frame = getframe(h);
            writeVideo(writerObj,frame);

    end 

    close(writerObj);
    %fprintf('%6.2f seconds per frame\n',cputime-time/ii)
end
    
