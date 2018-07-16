


% set parameters
A0 = [0 1; 1 0]';
B = [1 1]';
N = 2;

% patterns
pats = cell(1,N);
for i = 1 : N
    pats{i} = zeros(N,1);
    pats{i}(i) = 1;
end

% transitions = 0.05 : 0.05 : 0.95;
% transitions = 0.01 : 0.01 : 0.1;
transitions = 0.02 : 0.02 : 0.1;
slopes = zeros(size(transitions));
shifts = zeros(size(transitions));
xs = cell(size(slopes));
ys = cell(size(slopes));
As = cell(size(slopes));

parfor i = 1 : length(transitions)
    disp(num2str(transitions(i)))
    A = A0;
    A(1,2) = A(1,2) - transitions(i);
    A(1,1) = transitions(i);
    A(2,1) = A(2,1) - transitions(i);
    A(2,2) = transitions(i);
    As{i} = A;
    % simulate
    dur = 1e3; iter = 6e3;
    probs = ones(1,length(pats)) / length(pats);
    tic
    [Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
    toc; beep
    % analyze
    activity = squeeze(sum(Y,1))';
    durations = zeros(1,iter);
    for j = 1 : iter
        if sum(activity(j,:)) > 0
            durations(j) = find(activity(j,:)>0,1,'last');
        else
            durations(j) = 0;
        end
    end
    [c_d,e_d,bin_idx] = histcounts(durations,100);
    x = log10(e_d(2:end));
    y = log10(c_d/(sum(c_d)));
    x(isinf(y)) = [];
    y(isinf(y)) = [];
    x(y==0) = [];
    y(y==0) = [];
    xs{i} = x;
    ys{i} = y;
    f = polyfit(x(1:15),y(1:15),1);
    slopes(i) = f(1);
    shifts(i) = f(2);
end

%% plot
scatter(transitions, shifts, 'filled')
xlabel('autapse strength')
ylabel('shifts')
axis([0 1 1 2])
yyaxis right
scatter(transitions, slopes, 'filled')
ylabel('slopes')
axis([0 1 -2 -1])
prettify

%% plot
for i = 1 : length(transitions)
    scatter(xs{i}, ys{i}, '.')
    axis([0 3 -4 0])
    prettify; title(num2str(transitions(i)))
    hold on
    plot(xs{i},polyval([slopes(i) shifts(i)], xs{i}))
    hold off
    pause
end
