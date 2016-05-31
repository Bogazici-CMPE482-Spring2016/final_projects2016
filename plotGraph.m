function plotGraph(points,G)
    N=size(points,1);
    hold on;
    plot(points(:,1),points(:,2),'b.');
    for i=1:N
        for j=i:N
            if G(i,j) == 1
                x = [points(i,1),points(j,1)]';
                y = [points(i,2),points(j,2)]';
                plot(x,y,'b');
            end
        end
    end
    hold off;
end