radius = 2;
shield = [5 5  4 2; 2 2 1 6];
domain_x = 10;
domain_y = 20;
nodes = [4,4;
    1,1]
heatmap = heatmapper2(nodes, radius,shield,domain_x,domain_y)
% plot(heatmap(1,:),heatmap(2,:))
% hold on
% plot([5 5], [4 2])
%Shield = Nx4 for N shields with start_x,end_x,start_y,end_y.
function heatmap = heatmapper2(nodes, radius,shield,domain_x,domain_y)
%function to visualise radius of risk region for the geometry of the train
%based on people sitting at loctations `nodes` with a perimeter of social
%distancing `radius` and plastic blockades at locations `shields`. This is
%applied into `domain`, which assumes rectangular geometry of a train.
%works if nodes is a Nx2 matrix with first column the x position, second y
%position


theta = linspace(0,2*pi,100);
heatmap = zeros(2,100*length(nodes(:,1)))
for j = 1:length(nodes(:,1))

x_circle = radius*cos(theta) + nodes(j,1);%Defines an intial unsafe perimeter
y_circle = radius*sin(theta) + nodes(j,2);

x_circle(x_circle<0) = 0;
x_circle(x_circle>domain_x) = domain_x; 
y_circle(y_circle<0) = 0;
y_circle(y_circle>domain_y) = domain_y;%Snaps unsafe perimeter to domain walls where necessary

shield_interact = [];
for i = 1:length(shield(:,1))
shield_locations_y = linspace(shield(i,3),shield(i,4));
shield_locations_x = repmat(shield(i,1), [1,100])
   if min(min(sqrt((shield_locations_y-nodes(j,2)).^2 + (shield_locations_x-nodes(j,1)).^2)))<radius %checks shield interaction
       
      if shield_locations_x(1) < nodes(j,1) %barrier left of the node
          x_circle(x_circle < shield_locations_x) = shield_locations_x(x_circle < shield_locations_x);
      else %barrier to right of node
                    x_circle(x_circle > shield_locations_x) = shield_locations_x(x_circle > shield_locations_x);
%       in = inpolygon(shield_locations_x,shield_locations_y,x_circle,y_circle);
%       theta = zeros(1,length(in));
%       theta = atan(((shield_locations_y(in)-nodes(j,2))./(shield_locations_x(in)-nodes(j,1))));
% %       theta(shield_locations_x(in) < nodes(j,1)) = pi - theta;
% theta(theta<0) = pi+theta(theta<0);
%       n1= max(1,ceil(min(theta)*100/(2*pi)));
%       n2= min(100,floor(max(theta)*100/(2*pi)));
%       x_circle(n1:n2) = linspace(min(shield_locations_x(in)),max(shield_locations_x(in)),n2-n1+1)
%        y_circle(n1:n2) = linspace(min(shield_locations_y(in)),max(shield_locations_y(in)),n2-n1+1)
      end
      

heatmap(1,1+100*(j-1):100*(j-1) + 100) = x_circle;
heatmap(2,1+100*(j-1):100*(j-1) + 100) = y_circle;
end
end
hold on
plot(heatmap(1,1+100*(j-1):100*(j-1) + 100),heatmap(2,1+100*(j-1):100*(j-1) + 100))
end

end
