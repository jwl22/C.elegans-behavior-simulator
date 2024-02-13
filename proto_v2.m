% 컴퓨터 사양에 따라 일정 이상 개체 생성 시 에러 발생 가능

clc; clear; close all;
global fig;

% Create a uifigure
fig = uifigure('Name','C. elegans Growth Rate');
panel_x = 30; panel_y = 220; panel_width = 360; panel_height = 390;
fig_x = 600; fig_y = 300; fig_width = 1400; fig_height = 700;
axes_x = 400; axes_y = 20; axes_width = 970; axes_height = 680;  

panel = uipanel(fig, 'Position', [panel_x panel_y panel_width panel_height], 'BackgroundColor', 'w');
set(fig, "Position", [fig_x fig_y fig_width fig_height]);
ax = uiaxes(fig,'Position',[axes_x axes_y axes_width axes_height]);
axis(ax, [-40000 40000 -40000 40000 -25000 25000]);

view(ax, [0, 0]);
grid(ax, 'on');
pbaspect(ax, [9,9,5]);

% Create a label for displaying text
label_x = 100; label_y = 560; label_width = 250; label_height = 40;
textlabel_x = 40; text_label_y= 510; textlabel_width = 220; textlabel_height = 22;

textLabel_label = uilabel(fig, 'Text', '<Parameter Settings>', 'Position', [label_x, label_y, label_width, label_height], 'FontSize', 20, 'FontWeight', 'bold');
textLabel_ci = uilabel(fig, 'Text', 'Initial C. elegans L1 Number:', 'Position', [textlabel_x, text_label_y, textlabel_width, textlabel_height], 'FontSize', 13, 'FontWeight', 'bold');
textLabel_ei = uilabel(fig, 'Text', 'Initial C. elegans Eggs Number:', 'Position', [textlabel_x, text_label_y-50, textlabel_width, textlabel_height], 'FontSize', 13, 'FontWeight', 'bold');
textLabel_days = uilabel(fig, 'Text', 'Total Days:', 'Position', [textlabel_x, text_label_y-50*2, textlabel_width, textlabel_height], 'FontSize', 13, 'FontWeight', 'bold');
textLabel_ms = uilabel(fig, 'Text', 'Migration Speed(um):', 'Position', [textlabel_x, text_label_y-50*3, textlabel_width, textlabel_height], 'FontSize', 13, 'FontWeight', 'bold');
textLabel_ed = uilabel(fig, 'Text', 'Egg Laying Distance(um):', 'Position', [textlabel_x, text_label_y-50*4, textlabel_width, textlabel_height], 'FontSize', 13, 'FontWeight', 'bold');

% Create UIEditField for input
inputfield_x = 250; inputfield_y= 510; inputfield_width = 50; inputfield_height = 22;

inputField_ci = uieditfield(fig, 'numeric', 'Position', [inputfield_x, inputfield_y, inputfield_width, inputfield_height], 'Value', 0);
inputField_ei = uieditfield(fig, 'numeric', 'Position', [inputfield_x, inputfield_y-50, inputfield_width, inputfield_height], 'Value', 0);
inputField_days = uieditfield(fig, 'numeric', 'Position', [inputfield_x, inputfield_y-50*2, inputfield_width, inputfield_height], 'Value', 0);
inputField_ms = uieditfield(fig, 'numeric', 'Position', [inputfield_x, inputfield_y-50*3, inputfield_width, inputfield_height], 'Value', 0);
inputField_ed = uieditfield(fig, 'numeric', 'Position', [inputfield_x, inputfield_y-50*4, inputfield_width, inputfield_height], 'Value', 0);

% Create a button to trigger action
button_x = 310; button_y= 510; button_width = 67; button_height = 22;

btn_ci = uibutton(fig, 'push', 'Text', 'Submit', 'Position', [button_x, button_y, button_width, button_height], 'ButtonPushedFcn', @(src, event)buttonCallback_two(src));
btn_ei = uibutton(fig, 'push', 'Text', 'Submit', 'Position', [button_x, button_y-50, button_width, button_height], 'ButtonPushedFcn',  @(src, event)buttonCallback_two(src));
btn_days = uibutton(fig, 'push', 'Text', 'Submit', 'Position', [button_x, button_y-50*2, button_width, button_height], 'ButtonPushedFcn',  @(src, event)buttonCallback_two(src));
btn_ms = uibutton(fig, 'push', 'Text', 'Submit', 'Position', [button_x, button_y-50*3, button_width, button_height], 'ButtonPushedFcn',  @(src, event)buttonCallback_two(src));
btn_ed = uibutton(fig, 'push', 'Text', 'Submit', 'Position', [button_x, button_y-50*4, button_width, button_height], 'ButtonPushedFcn',  @(src, event)buttonCallback_two(src));
control_button = uicontrol(fig, 'String', 'Start', 'Callback', @(src, event)buttonCallback(src), 'Position', [130, 230, 150, 50], 'FontSize', 20, 'FontWeight','bold');

% Control Button (To start the simulation)
uiwait(fig);

%% parameter
c_initial = inputField_ci.Value; % initial c.elegans(L1) number
egg_initial = inputField_ei.Value; % initial egg number
days = inputField_days.Value; % simulation days
migration_speed = inputField_ms.Value;
egglaying_dist = inputField_ed.Value;

%% simulation code
max_c_size = c_initial; % max c.elegans size
max_egg_size = egg_initial; % max egg size
steps = days*3*24; % iteration number

x = mvnrnd(0,100,c_initial)';
y = mvnrnd(0,100,c_initial)';
z = mvnrnd(0,100,c_initial)';

others = 100000 * ones(1, max_c_size - size(x,2));
x = [x others];
y = [y others];
z = [z others];
x_cumul = zeros(steps, max_c_size);   % c.elegans position
y_cumul = zeros(steps, max_c_size);
z_cumul = zeros(steps, max_c_size);
center_x_cumul = zeros(steps, max_c_size);  % center position
center_y_cumul = zeros(steps, max_c_size);
center_z_cumul = zeros(steps, max_c_size);
x_cumul(1:24*3*3,:) = ones(24*3*3,1)*x;
y_cumul(1:24*3*3,:) = ones(24*3*3,1)*y;
z_cumul(1:24*3*3,:) = ones(24*3*3,1)*z;
c_ages = -1*ones(1,max_c_size);
c_ages(1:c_initial) = 0;
c_num = zeros(1,steps);
c_num(1:24*3*3) = c_initial;

eggs_x_cumul = 100000*ones(steps, max_egg_size);    % egg position
eggs_y_cumul = 100000*ones(steps, max_egg_size);
eggs_z_cumul = 100000*ones(steps, max_egg_size);
egg_ages = -1*ones(1,max_egg_size);
egg_ages(1:egg_initial) = 0;
egg_num = zeros(1,steps);
egg_num(1:24*3*3) = egg_initial;

for i=24*3*3+1:steps
    x_cumul(i,:) = x_cumul(i-1,:);
    y_cumul(i,:) = y_cumul(i-1,:);
    z_cumul(i,:) = z_cumul(i-1,:);
    center_x_cumul(i,:) = center_x_cumul(i-1,:);
    center_y_cumul(i,:) = center_y_cumul(i-1,:);
    center_z_cumul(i,:) = center_z_cumul(i-1,:);
    eggs_x_cumul(i,:) = eggs_x_cumul(i-1,:);
    eggs_y_cumul(i,:) = eggs_y_cumul(i-1,:);
    eggs_z_cumul(i,:) = eggs_z_cumul(i-1,:);
    c_num(i) = c_num(i-1);
    egg_num(i) = egg_num(i-1);

    %% death
    death = c_ages >= 288;
    death_num = length(find(death));
    if death_num > 0
        c_ages = [c_ages(death_num+1:end) -1*ones(1,death_num)];
        x_cumul(i,:) = [x_cumul(i,death_num+1:end) 100000*ones(1,death_num)];
        y_cumul(i,:) = [y_cumul(i,death_num+1:end) 100000*ones(1,death_num)];
        z_cumul(i,:) = [z_cumul(i,death_num+1:end) 100000*ones(1,death_num)];
        c_num(i) = c_num(i) - death_num;
    end

    %% egg laying
    target_idx = find(c_ages<144 & c_ages >= 0);
    laying_idx = target_idx(rem(c_ages(target_idx),12)==0);
    % laying_idx = find(rem(c_ages(c_ages<144 & c_ages>=0),12)==0);
    laying_num = length(laying_idx);
    if laying_num > 0 % 1egg/4hr
        % laying_idx = find(c_ages == 0 | c_ages == 1);
        
        % x_vec = x_cumul(i,laying_idx) - center_x_cumul(i,laying_idx);
        % y_vec = y_cumul(i,laying_idx) - center_y_cumul(i,laying_idx);
        % z_vec = z_cumul(i,laying_idx) - center_z_cumul(i,laying_idx);
        % 
        % theta = atan2(y_vec, x_vec);    % xy plane
        % phi = atan2(z_vec, sqrt(x_vec.^2 + y_vec.^2));  % (xy)z plane

        [sph_x, sph_y, sph_z] = sphere(50);
        sph_x = sph_x.*egglaying_dist;
        sph_y = sph_y.*egglaying_dist;
        sph_z = sph_z.*egglaying_dist;
        new_egg_pos = zeros(laying_num, 3);
        for j=1:laying_num
            flag = 0;
            while flag == 0
                rand_idx1 = randi(51);
                rand_idx2 = randi(51);
                sel_point = [sph_x(rand_idx1, rand_idx2)+x_cumul(i,laying_idx(j)) sph_y(rand_idx1, rand_idx2)+y_cumul(i,laying_idx(j)) sph_z(rand_idx1, rand_idx2)+z_cumul(i,laying_idx(j))];
                cur_pos = [x_cumul(i,laying_idx(j)) y_cumul(i,laying_idx(j)) z_cumul(i,laying_idx(j))];
                center_pos = [center_x_cumul(i, laying_idx(j)) center_y_cumul(i, laying_idx(j)) center_z_cumul(i, laying_idx(j))];
                if norm(sel_point - center_pos) > norm(cur_pos - center_pos)
                    new_egg_pos(j,:) = sel_point;
                    flag = 1;
                end
            end
        end

        % new_egg_pos = mvnrnd([x_vec+egglaying_dist.*cos(phi).*cos(theta); ...
        %     y_vec+egglaying_dist.*cos(phi).*sin(theta); ...
        %     z_vec+egglaying_dist.*sin(phi)],egglaying_dist.*eye(laying_num));
        eggs_x_cumul(i,egg_num(i)+1:egg_num(i)+laying_num) = new_egg_pos(:,1);
        eggs_y_cumul(i,egg_num(i)+1:egg_num(i)+laying_num) = new_egg_pos(:,2);
        eggs_z_cumul(i,egg_num(i)+1:egg_num(i)+laying_num) = new_egg_pos(:,3);

        egg_ages(egg_num(i)+1:egg_num(i)+laying_num) = 0;
    
        % center_x_cumul(i,laying_idx) = eggs_x_cumul(i,egg_num(i)+1:egg_num(i)+laying_num);
        % center_y_cumul(i,laying_idx) = eggs_y_cumul(i,egg_num(i)+1:egg_num(i)+laying_num);
        % center_z_cumul(i,laying_idx) = eggs_z_cumul(i,egg_num(i)+1:egg_num(i)+laying_num);
        
        egg_num(i) = egg_num(i) + laying_num;
    end

    %% proliferation
    pro_idx = find(egg_ages == 288);
    pro_num = length(pro_idx);
    if pro_num > 0
        x_cumul(i,c_num(i)+1:c_num(i)+pro_num) = eggs_x_cumul(i,pro_idx);
        y_cumul(i,c_num(i)+1:c_num(i)+pro_num) = eggs_y_cumul(i,pro_idx);
        z_cumul(i,c_num(i)+1:c_num(i)+pro_num) = eggs_z_cumul(i,pro_idx);

        tmp = mvnrnd([0 0 0],[1 1 1;1 1 1;1 1 1], pro_num);

        center_x_cumul(i,end+1:end+pro_num) = eggs_x_cumul(i,pro_idx)+tmp(:,1)';
        center_y_cumul(i,end+1:end+pro_num) = eggs_y_cumul(i,pro_idx)+tmp(:,2)';
        center_z_cumul(i,end+1:end+pro_num) = eggs_z_cumul(i,pro_idx)+tmp(:,3)';

        eggs_x_cumul(i,1:egg_num(i)) = [eggs_x_cumul(i,pro_num+1:egg_num(i)) 100000*ones(1,pro_num)];
        eggs_y_cumul(i,1:egg_num(i)) = [eggs_y_cumul(i,pro_num+1:egg_num(i)) 100000*ones(1,pro_num)];
        eggs_z_cumul(i,1:egg_num(i)) = [eggs_z_cumul(i,pro_num+1:egg_num(i)) 100000*ones(1,pro_num)];

        egg_ages(1:egg_num(i)) = [egg_ages(pro_num+1:egg_num(i)) -1*(ones(1,pro_num))];
        egg_num(i) = egg_num(i) - pro_num;     
        c_ages(end+1:end+pro_num) = -1*ones(1,pro_num);
        c_num(i) = c_num(i) + pro_num;
        % center_x_cumul(i,end+1:end+pro_num) = zeros(1,pro_num);
        % center_y_cumul(i,end+1:end+pro_num) = zeros(1,pro_num);
        % center_z_cumul(i,end+1:end+pro_num) = zeros(1,pro_num);
    end

    %% move
    move_idx = find(c_ages<24*2*3 & c_ages>=0);
    move_num = length(move_idx);
    if move_num > 0
        x_vec = x_cumul(i,move_idx) - center_x_cumul(i,move_idx);
        y_vec = y_cumul(i,move_idx) - center_y_cumul(i,move_idx);
        z_vec = z_cumul(i,move_idx) - center_z_cumul(i,move_idx);
    
        theta = atan2(y_vec, x_vec);    % xy plane
        phi = atan2(z_vec, sqrt(x_vec.^2 + y_vec.^2));  % (xy)z plane
    
        xyz_pos = mvnrnd([x_cumul(i,move_idx)+migration_speed/3.*cos(phi).*cos(theta), y_cumul(i,move_idx)+migration_speed/3.*cos(phi).*sin(theta), z_cumul(i,move_idx)+migration_speed/3.*sin(phi)], (migration_speed/6)^2.*ones(1,move_num*3));
    
        x_vec = xyz_pos(1:move_num);
        y_vec = xyz_pos(move_num+1:2*move_num);
        z_vec = xyz_pos(2*move_num+1:3*move_num);
    
        x_cumul(i,move_idx) = x_vec;
        y_cumul(i,move_idx) = y_vec;
        z_cumul(i,move_idx) = z_vec;
    end

    %% aging
    % if rem(i,3*24) == 0
    c_ages(1:c_num(i)) = c_ages(1:c_num(i)) + 1;
    egg_ages(1:egg_num(i)) = egg_ages(1:egg_num(i)) + 1;
    % end
end

%% Generating plots

ball = line(ax, inf,inf);
set(ball, 'linestyle', 'none', 'marker', 'o', 'markeredgecolor', 'b', 'markerfacecolor', 'b', 'markersize', 20, 'XData', 0, 'YData', 0, 'ZData', 0);

worms = line(ax, inf,inf);
set(worms, 'linestyle', 'none', 'marker', 'o', 'markeredgecolor', 'r', 'markerfacecolor', 'r', 'markersize', 2, 'XData', 100000*ones(1,max_c_size), 'YData', 100000*ones(1,max_c_size), 'ZData', 100000*ones(1,max_c_size));

eggs = line(ax, inf,inf);
set(eggs, 'linestyle', 'none', 'marker', 'o', 'markeredgecolor', 'g', 'markerfacecolor', 'g', 'markersize', 2, 'XData', 100000*ones(1,max_egg_size), 'YData', 100000*ones(1,max_egg_size), 'ZData', 100000*ones(1,max_egg_size));

set(ax,'FontSize',14)
legatt = legend(ax, 'Bacteria', 'C. Elegans Adults', 'C. Elegans L1~Eggs');
legatt.AutoUpdate = 'off';

x = [-45000 45000];

y = [-0 0];

z1 = [-15000 -15000];
z2 = [-5000 -5000];
z3 = [5000 5000];
z4 = [15000 15000];

line(ax, x, y, z1, 'Color', '#868e96', 'LineStyle', '--', 'LineWidth', 1.5);
line(ax, x, y, z2, 'Color', '#868e96', 'LineStyle', '--', 'LineWidth', 1.5);
line(ax, x, y, z3, 'Color', '#868e96', 'LineStyle', '--', 'LineWidth', 1.5);
line(ax, x, y, z4, 'Color', '#868e96', 'LineStyle', '--', 'LineWidth', 1.5);

string_a = text(ax, -39000, 0, 20000, '', 'FontSize', 17, 'Color', 'magenta');
string_b = text(ax, -39000, 0, 10000, '', 'FontSize', 17, 'Color', 'magenta');
string_c = text(ax, -39000, 0, 0, '', 'FontSize', 17, 'Color', 'magenta');
string_d = text(ax, -39000, 0, -10000, '', 'FontSize', 17, 'Color', 'magenta');
string_e = text(ax, -39000, 0, -20000, '', 'FontSize', 17, 'Color', 'magenta');
string_sum = text(ax, 42000, 0, -29000, '', 'FontSize', 17, 'Color', 'black');
string_sum_egg = text(ax, 42000, 0, -32000, '', 'FontSize', 17, 'Color', 'black');

% ax = uiaxes(fig);
% waitforbuttonpress
for i = 1:(steps)
    x_pos = x_cumul(i, :);
    y_pos = y_cumul(i, :);
    z_pos = z_cumul(i, :);

    x_0 = 0;
    y_0 = 0;
    z_0 = 0;

    a_count = 0;
    b_count = 0;
    c_count = 0;
    d_count = 0;
    e_count = 0;
    
    % Counting C elegans for each sections A B C D E
    if size(z_pos(1:c_num(i))) == 1
         if z_pos(1:c_num(i)) <= -15000
            e_count = e_count + 1;
        elseif z_pos(1:c_num(i)) <= -5000
            d_count = d_count + 1;
        elseif z_pos(1:c_num(i)) <= 5000
            c_count = c_count + 1;
        elseif z_pos(1:c_num(i)) <= 15000
            b_count = b_count + 1;
        elseif z_pos(1:c_num(i)) <= 25000
            a_count = a_count + 1;
         end
    else
        z_count = z_pos(1:c_num(i));

        for ii = 1:size(z_count, 2)
            if z_count(ii) <= -15000
                e_count = e_count + 1;
            elseif z_count(ii) <= -5000
                d_count = d_count + 1;
            elseif z_count(ii) <= 5000
                c_count = c_count + 1;
            elseif z_count(ii) <= 15000
                b_count = b_count + 1;
            elseif z_count(ii) <= 25000
                a_count = a_count + 1;
            end
        end
    end

    wormsum = num2str(a_count+b_count+c_count+d_count+e_count);
    eggsum = num2str(egg_num(i));
    a_count = num2str(a_count);
    b_count = num2str(b_count);
    c_count = num2str(c_count);
    d_count = num2str(d_count);
    e_count = num2str(e_count);
    
    % Plot C elegans and Bacteria
    % sum_count = a_count+b_count+c_count+d_count+e_count;
    % plot3(x_0, y_0, z_0, 'Marker', 'o', 'MarkerSize', 20, 'MarkerFaceColor','blue', 'Color', 'blue'); hold on;
    % plot3(x_pos(1:c_num(i)),y_pos(1:c_num(i)),z_pos(1:c_num(i)),'.r','markersize',10); hold off;
    set(worms, 'xdata', x_pos(1:c_num(i)), 'ydata', y_pos(1:c_num(i)), 'zdata', z_pos(1:c_num(i)))
    set(eggs, 'xdata', eggs_x_cumul(i,1:egg_num(i)), 'ydata', eggs_y_cumul(i,1:egg_num(i)), 'zdata', eggs_z_cumul(i,1:egg_num(i)))

    set( string_a, 'String', ['A: ' a_count])
    set( string_b, 'String', ['B: ' b_count])
    set( string_c, 'String', ['C: ' c_count])
    set( string_d, 'String', ['D: ' d_count])
    set( string_e, 'String', ['E: ' e_count])
    set( string_sum, 'String', ['Sum: ' wormsum])
    set( string_sum_egg, 'String', ['Egg Sum: ' eggsum])

    time_txt = 'Time: ';
    total_time = 1/3*i;
    total_day = floor(total_time / 24);
    total_hr = floor(total_time - total_day*24); 

    % if total_day == 12 && total_hr == 0
    %     result = ['-12-', a_count, '/', b_count, '/', c_count, '/', d_count, '/', e_count]
    % elseif total_day == 15 && total_hr == 0
    %     result = ['-15-', a_count, '/', b_count, '/', c_count, '/', d_count, '/', e_count]
    % elseif total_day == 18 && total_hr == 0
    %     result = ['-18-', a_count, '/', b_count, '/', c_count, '/', d_count, '/', e_count]
    % elseif total_day == 21 && total_hr == 23
    %     result = ['-21-', a_count, '/', b_count, '/', c_count, '/', d_count, '/', e_count]
    % end

    total_day = num2str(total_day);
    txt_day = ' Day ';
    
    total_hr = num2str(total_hr);
    txt_hr = ' H';

    txt_blank = ' ';
    
    str_tmp = strcat(time_txt, total_day);
    str_tmp = strcat(str_tmp, txt_day);
    str_tmp = strcat(str_tmp, txt_blank);
    str_tmp = strcat(str_tmp, total_hr);
    txt = strcat(str_tmp, txt_hr);
    % txt = strcat(str_tmp, time_txt3);

    % txt = ['Time : ' num2str(i) " sec"];
    xlabel(ax, txt, 'FontSize',15,'FontWeight','bold')

    drawnow     % 결과만 보고싶으면 주석
end

% % Function to be executed when the button is pushed
% function submitCallback(editField)
% 
%     value = editField.Value;
%     disp(['Input Value: ' num2str(value)]);
% end

% Function to be executed when the button is pressed
function buttonCallback(src)
    global fig;
    % Change the text on the button
    if strcmp(src.String, 'Start')
        src.String = 'Loading...';
        uiresume(fig);
    else
        src.String = 'Start';
    end
end

function buttonCallback_two(src)
    % Change the text on the button
    if strcmp(src.Text, 'Submit')
        src.Text = 'Submitted!';
    else
        src.String = 'Submit';
    end
end