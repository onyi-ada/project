function DominantConstraints()
%function DominantConstraints
global A_sorted A SA SinkA Duration ScheduleTable SlackTime CP
read = fopen('file_to_open.txt');
%file_to_open.txt contains three inputs on seperate lines
%the file name, directory and and name to save gant chart as
input = fgets(read);
split = strsplit(input,'|');
filename = char(split(1));
directory = char(split(2));
chartname = char(split(3));
fclose(read);

%function DominantConstraints
disp(' ');
disp('---------- Determining Dominant Precedence Constraints ----------');

%%GET PROJECT INFORMATION
%filename = input('Specify name of file to import data. ', 's');
disp(['Please wait...reading data from ', filename,'.xls.']);

C = xlsread(filename,'AdjMatrix');
FF = xlsread(filename,'FF'); % Matrices with the constraint time for each type of constraint
FS = xlsread(filename,'FS');
SS = xlsread(filename,'SS');
SF = xlsread(filename,'SF');
Duration =xlsread(filename,'Duration'); %Vector with activity time durations 
A = zeros(size(C));
A(1,:)=C(1,:);
A(:,1)=C(:,1);
for i=2:size(C,1)
    for j=2:size(C,1)
    if C(i,j)>=1
        A(i,j)=1;
    end
    j = j+1;
    end
    i= i+1;
end

tm = istril(A(2:end,2:end)); % want to know if A is already lower triangular if not, we need to sort it.
%tm = isequal(A(2:end,2:end),tril(A(2:end,2:end)));
order = A(2:end,1); %Contains the activity labels in the sequence as-given
%%Sort A Matrix
if tm == 0
  %%Identify Source Activity (SA)
  SA = find(sum(A(2:end,2:end),2)==0);  
  disp(['Este es el valor de SA: ' num2str(SA)]);
  SinkA = find(sum(A(2:end,2:end),1)==0);
    disp(['Este es el valor de SinkA: ' num2str(SinkA)]);
  SortMatrix(A,SA,SinkA);
  %disp('This is the matrix from the first sort procedure:');
  %disp(A_sorted);
  tm = istril(A_sorted(2:end,2:end));
  %tm = isequal(A_sorted(2:end,2:end),tril(A_sorted(2:end,2:end)));
  if tm == 0
      A = A_sorted'; 
      SortMatrix(A,SA,SinkA);
      A_sorted = A_sorted';
      tm = istril(A_sorted(2:end,2:end));
      %tm = isequal(A_sorted(2:end,2:end),tril(A_sorted(2:end,2:end)));
      A = A_sorted;
  else
      A = A_sorted;
      
  end
% Prepare A sequence for Input Data
order = A(2:end,1); %Contains the activity labels in the sequence that allows a lower triangular matrix
change_order = zeros(size(order,1),2);
change_order(:,1)= order;
for j = 1:size(order,1)
    change_order(j,2) = find(order == j);
end

%%InputData(change_order,filename)
FF_sortrows= horzcat(FF,change_order);
FF_sortrows =sortrows(FF_sortrows,size(FF_sortrows,2));
FF_sortcols = horzcat(FF_sortrows(1:end,1:end-2)',change_order);
FF_sortcols = sortrows(FF_sortcols,size(FF_sortrows,2));
FF = FF_sortcols(1:end,1:end-2)';

FS_sortrows= horzcat(FS,change_order);
FS_sortrows =sortrows(FS_sortrows,size(FS_sortrows,2));
FS_sortcols = horzcat(FS_sortrows(1:end,1:end-2)',change_order);
FS_sortcols = sortrows(FS_sortcols,size(FS_sortrows,2));
FS = FS_sortcols(1:end,1:end-2)';

SS_sortrows= horzcat(SS,change_order);
SS_sortrows =sortrows(SS_sortrows,size(SS_sortrows,2));
SS_sortcols = horzcat(SS_sortrows(1:end,1:end-2)',change_order);
SS_sortcols = sortrows(SS_sortcols,size(SS_sortrows,2));
SS = SS_sortcols(1:end,1:end-2)';

SF_sortrows= horzcat(SF,change_order);
SF_sortrows =sortrows(SF_sortrows,size(SF_sortrows,2));
SF_sortcols = horzcat(SF_sortrows(1:end,1:end-2)',change_order);
SF_sortcols = sortrows(SF_sortcols,size(SF_sortrows,2));
SF = SF_sortcols(1:end,1:end-2)';

Duration_sort = horzcat(Duration,change_order);
Duration_sort = sortrows(Duration_sort,size(Duration_sort,2));
Duration = Duration_sort(:,1:size(Duration_sort,2)-size(change_order,2));
end

Constraints (:,:,1)= FS;
Constraints(:,:,2)= FF;
Constraints(:,:,3)= SS;
Constraints(:,:,4)=SF;
SumConstraints = zeros(size(Constraints(:,:,1)));

%Find FS constraints
%This procedure will create a (nx2) matrix with the i,j locations of each
%constraint

[row column]= find(Constraints(:,:,1)>=0);
Nr_FS = size(row,1)-size(Constraints(:,:,1),1);
if Nr_FS > 0
    Find_FS = zeros(Nr_FS,2);
    k = 1;
for i=1:size(row,1)
    if row(i)~=column(i)
            Find_FS(k,:)= [row(i) column(i)];
            SumConstraints(row(i),column(i))= SumConstraints(row(i),column(i))+1;
            k = k+1;
    end
end
else
    Find_FS =[];
end

% Find FF constraints
[row column]= find(Constraints(:,:,2)>=0);
Nr_FF = size(row,1)-size(Constraints(:,:,2),1);
if Nr_FF > 0
    Find_FF = zeros(Nr_FF,2);
    k = 1;
for i=1:size(row,1)
    if row(i)~=column(i)
            Find_FF(k,:)= [row(i) column(i)];
            SumConstraints(row(i),column(i))= SumConstraints(row(i),column(i))+1;
            k = k+1;
    end
end
else 
    Find_FF =[];
end


%Find SS Constraints
[row column]= find(Constraints(:,:,3)>=0);
Nr_SS = size(row,1)-size(Constraints(:,:,3),1);
if Nr_SS > 0
    Find_SS = zeros(Nr_SS,2);
    k = 1;
for i=1:size(row,1)
    if row(i)~=column(i)
            Find_SS(k,:)= [row(i) column(i)];
            SumConstraints(row(i),column(i))= SumConstraints(row(i),column(i))+1;
            k = k+1;
    end
end
else
    Find_SS = [];
end

%Find SF Constriants
[row column]= find(Constraints(:,:,4)>=0);
Nr_SF = size(row,1)-size(Constraints(:,:,4),1);
if Nr_SF > 0
    Find_SF = zeros(Nr_SF,2);
    k = 1;
for i=1:size(row,1)
    if row(i)~=column(i)
            Find_SF(k,:)= [row(i) column(i)];
            SumConstraints(row(i),column(i))= SumConstraints(row(i),column(i))+1;
            k = k+1;
    end
end
else
    Find_SF = [];
end

disp('-------------- Matrix with Total Number of Constraints -------------');
SumConstraints

SingleConstraint = find(sum(SumConstraints,2)==1); %Shows the row numbers assocdiated with activities w/single constraint
MultipleConstraints = find(sum(SumConstraints,2)>1); % Shows the row numbers idem but w/multiple constraints


ScheduleTable = zeros(size(Duration,1),7); %This schedule table has the following columns: Activity Label, Nr. constriants, Dominant type of constraint, constrainted by activity label, constraint time, ST and FT
 
ScheduleTable(1,:) = [order(1) 0 0 0 0 0 Duration(1)];

%%Identify the type of Constraint for activities w/single constraint
for i = 1:size(SingleConstraint,1)
    k = SingleConstraint(i);  % Row number of activity w/single constraint
    ScheduleTable(k,1)=order(k); % Added activity label
    ScheduleTable(k,2) = 1; % B/C activity has only  one constraint
    
    ScheduleTable(k,3)=find(Constraints(k,find(SumConstraints(k,:),1),:)>=0); % Type of constraint
    % 1: FS, 2: FF, 3: SS, 4: SF
    ScheduleTable(k,4) = order(find(SumConstraints(k,:),1)); % Identify activity that constrains activity k
    ScheduleTable(k,5)=Constraints(k,find(SumConstraints(k,:),1),ScheduleTable(k,3)); % Constraint time
end

disp('-----Schedule Table populated with single-constrained activities -----'); 
ScheduleTable

%%Start Determining ST and FT
NextRowActivity = 2; 
NextMultCstrAct = 1;
for a = 2:size(order,1)
    switch ScheduleTable(NextRowActivity,3) 
                case 1 % FS
                    ScheduleTable(NextRowActivity,6)= ScheduleTable(ScheduleTable(:,1)==ScheduleTable(NextRowActivity,4),7)+ScheduleTable(NextRowActivity,5); %ST = FT(constrained by activity) + Constraint Time
                    ScheduleTable(NextRowActivity,7)=ScheduleTable(NextRowActivity,6)+ Duration(NextRowActivity);% FT = ST + Activity Duration
                case 2 %FF
                    ScheduleTable(NextRowActivity,7)= ScheduleTable(ScheduleTable(:,1)==ScheduleTable(NextRowActivity,4),7) + ScheduleTable(NextRowActivity,5); % FT = FT(constrained by activity) + Constraint Time
                    ScheduleTable(NextRowActivity,6)= ScheduleTable(NextRowActivity,7)- Duration(NextRowActivity); %ST = FT - Activity Duration
                case 3 % SS
                    ScheduleTable(NextRowActivity,6)= ScheduleTable(ScheduleTable(:,1)==ScheduleTable(NextRowActivity,4),6)+ScheduleTable(NextRowActivity,5); % ST = ST(constrained by activity) + Constraint Time
                    ScheduleTable(NextRowActivity,7)= ScheduleTable(NextRowActivity,6)+ Duration(NextRowActivity); % FT = ST + Activity Duration
                case 4 %SF
                    ScheduleTable(NextRowActivity,7)= ScheduleTable(ScheduleTable(:,1)==ScheduleTable(NextRowActivity,4),6) + ScheduleTable(NextRowActivity,5);% FT = ST(Constrained by activity)+ Constraint time
                    ScheduleTable(NextRowActivity,6)= ScheduleTable(NextRowActivity,7) - Duration(NextRowActivity);% ST = FT - Activity Duration
                case 0 %Determine dominant constraint
                    ScheduleTable(NextRowActivity,1)=order(NextRowActivity); % Add Activity label
                    Nr_Cstr = sum(SumConstraints(MultipleConstraints(NextMultCstrAct),:)); % Number of constraints  
                    ScheduleTable(NextRowActivity,2)= Nr_Cstr;
                    Constrainedby = find(SumConstraints(MultipleConstraints(NextMultCstrAct),:)>0)';% Identify column activities that put a constraint on row activity(I eliminated this part: find(SumConstraints(X,:)>0,2) don't know why I limited to the first two.
                    ID_Cnstr=zeros(Nr_Cstr,1); % This vector will collect the type of constraint --this was needed for the cases in which I have one activity w/multiple constraints
                    Search4Dominant = zeros(Nr_Cstr,6); % Columns in this table: Activity Label, Constrained by, Type of Constraint, Constraint time, ST, and FT.
                    Search4Dominant(:,1)= ScheduleTable(NextRowActivity,1); %Added first column with activity label
                    
                    if Nr_Cstr > size(Constrainedby,1) %If one column activity imposes more than one constraint
                        Constrainedby2 = zeros(Nr_Cstr,1);
                        counter = 1;
                        for l=1:size(Constrainedby,1)
                            Cnstr = find(Constraints(MultipleConstraints(NextMultCstrAct),Constrainedby(l),:)>=0);
                            for m=1:SumConstraints(MultipleConstraints(NextMultCstrAct),Constrainedby(l))
                                Constrainedby2(counter,1)=Constrainedby(l);
                                ID_Cnstr(counter,1)= Cnstr(m,1);
                                counter = counter +1;
                            end
                        end
                        Constrainedby = Constrainedby2;
                    else
                        %counter = 1;
                        for j = 1:Nr_Cstr
                            ID_Cnstr (j,1)=find(Constraints(MultipleConstraints(NextMultCstrAct),Constrainedby(j,1),:)>=0,1);
                        end
                                                 
                    end
                        
                    for j = 1:Nr_Cstr
                        %NextMultCstrAct
                        %j
                        %Nr_Cstr
                        Search4Dominant(j,2)=order(Constrainedby(j)); % identify the activity label that puts the constraint
                        Search4Dominant(j,3)=ID_Cnstr(j); %Identify type of constraint
                        Search4Dominant(j,4)=Constraints(MultipleConstraints(NextMultCstrAct),Constrainedby(j),ID_Cnstr(j)); % Constraint Time                    
                        
                    
                        switch Search4Dominant(j,3)
                            case 1
                                Search4Dominant(j,5)= ScheduleTable(ScheduleTable(:,1)==Search4Dominant(j,2),7)+Search4Dominant(j,4); %ST = FT(constrained by activity) + Constraint Time
                                Search4Dominant(j,6)= Search4Dominant(j,5)+ Duration(NextRowActivity);% FT = ST + Activity Duration
                            case 2
                                Search4Dominant(j,6)= ScheduleTable(ScheduleTable(:,1)==Search4Dominant(j,2),7) + Search4Dominant(j,4); % FT = FT(constrained by activity) + Constraint Time 
                                Search4Dominant(j,5)=Search4Dominant(j,6)- Duration(NextRowActivity);
                            case 3
                                Search4Dominant(j,5)=ScheduleTable(ScheduleTable(:,1)==Search4Dominant(j,2),6)+Search4Dominant(j,4); % ST = SS(constrined by activity) + Constraint time
                                Search4Dominant(j,6)=Search4Dominant(j,5)+Duration(NextRowActivity); % FT = S+ Activity Duration
                            otherwise
                                Search4Dominant(j,6)=ScheduleTable(ScheduleTable(:,1)==Search4Dominant(j,2),6)+Search4Dominant(j,4); % FT = SS(constrained by activity) + Constraint time
                                Search4Dominant(j,5)=Search4Dominant(j,6) - Duration(NextRowActivity);
                        end
                     
                    end
                        %Search4Dominant
                        %ScheduleTable
                    
                    DomCnstr = find(Search4Dominant(:,6)==max(Search4Dominant(:,6))); 
                    % Dominant constraint is the one that yields the latest
                    % FT.  DomCnstr indicates the row number of
                    % Search4Dominant Table
                    
                    % NEED TO INLCUDE HERE THE CASE WHEN THERE ARE MULTIPLE
                    % CP'S, WHICH OCCURS WHEN I HAVE MORE THAN TWO
                    % CONSTRAINTS WITH THE SAME FT.
                    ScheduleTable(NextRowActivity,3)=Search4Dominant(DomCnstr,3);
                    ScheduleTable(NextRowActivity,4)=Search4Dominant(DomCnstr,2);
                    ScheduleTable(NextRowActivity,5)=Search4Dominant(DomCnstr,4);
                    ScheduleTable(NextRowActivity,6)=Search4Dominant(DomCnstr,5);
                    ScheduleTable(NextRowActivity,7)=Search4Dominant(DomCnstr,6);
                    NextMultCstrAct = NextMultCstrAct +1;
                    
     end
                                                            
           NextRowActivity = NextRowActivity + 1; 
end
disp('----------- Scheduel table ------------');
disp('  ');
disp(ScheduleTable);

%% Determine Slack Matrix

SlackTime = zeros(size(Constraints(:,:,1)));

for i=1:size(SlackTime,1)
    for j = 1:size(SlackTime,2)
    if SumConstraints(i,j)>=1
        SlackTime(i,j)=nan;
    end
    end
end

if isempty(Find_FS)== 0 %Determine Slack time from FS constraints
    for i = 1:size(Find_FS,1)
        SlackTime_value = ScheduleTable(Find_FS(i,1),6)-ScheduleTable(Find_FS(i,2),7)-Constraints(Find_FS(i,1),Find_FS(i,2),1);
        if isnan(SlackTime(Find_FS(i,1),Find_FS(i,2))) || SlackTime(Find_FS(i,1),Find_FS(i,2)) > SlackTime_value 
            SlackTime(Find_FS(i,1),Find_FS(i,2))= SlackTime_value;
        end
    end
end

if isempty(Find_FF)== 0
    for i = 1:size(Find_FF,1) % Determine the Slack time for FF constraints
        SlackTime_value =ScheduleTable(Find_FF(i,1),7)-ScheduleTable(Find_FF(i,2),7)-Constraints(Find_FF(i,1),Find_FF(i,2),2);
        if isnan(SlackTime(Find_FF(i,1),Find_FF(i,2))) || SlackTime(Find_FF(i,1),Find_FF(i,2)) > SlackTime_value 
            SlackTime(Find_FF(i,1),Find_FF(i,2))= SlackTime_value;
        end
    end
end

if isempty(Find_SS)== 0 % Determine Slack time for SS constraints
    for i=1:size(Find_SS,1)
        SlackTime_value=ScheduleTable(Find_SS(i,1),6)-ScheduleTable(Find_SS(i,2),6)-Constraints(Find_SS(i,1),Find_SS(i,2),3);
        if isnan(SlackTime(Find_SS(i,1),Find_SS(i,2))) || SlackTime(Find_SS(i,1),Find_SS(i,2)) > SlackTime_value
            SlackTime(Find_SS(i,1),Find_SS(i,2))= SlackTime_value;
        end
    end
end

if isempty(Find_SF)== 0 % Determine Slack Time for SF constraints
    for i=1:size(Find_SF,1)
        SlackTime_value=ScheduleTable(Find_SF(i,1),7)-ScheduleTable(Find_SF(i,2),6)-Constraints(Find_SF(i,1),Find_SF(i,2),4);
        if isnan(SlackTime(Find_SF(i,1),Find_SF(i,2))) || SlackTime(Find_SF(i,1),Find_SF(i,2)) > SlackTime_value
            SlackTime(Find_SF(i,1),Find_SF(i,2))=SlackTime_value;
        end
    end
end

for i=1:size(SlackTime,1)
    for j = 1:size(SlackTime,2)
    if SumConstraints(i,j)<=0
        SlackTime(i,j)=nan;
    end
    end
end
disp('-------------Slack Time Matrix ---------------');
disp(' ');
disp(SlackTime);

CPath(A, Duration, SlackTime,ScheduleTable);
DDC = DominantDisruptiveConstraints(ScheduleTable,CP,Duration);
CreateGanttChart(ScheduleTable, CP, directory, DDC, chartname);
quit force;
end

%% Identify the Dominant constraints for activities w/more than one constraint
% for i = 1:size(MultipleConstraints,1)
%     k = sum(SumConstraints(MultipleConstraints(i),:),2) %Nr of constraints  **THIS IS NOT IDENTIFYING THAT THE NR OF CONSTRIANTS
%     Constrainedby = find(SumConstraints(MultipleConstraints(i),:)>0,2)';
%     Search4Dominant= zeros(k,6); % Columns in this table: Activity Label, Constrained by, Type of Constraint, Constraint time, ST, and FT.  
%     Search4Dominant(:,1)= MultipleConstraints(i); %Added first column with activity label
%     for j = 1:k
%         Search4Dominant(j,2)=order(Constrainedby(j)); % identify the activity that puts the constraint
%         Search4Dominant(j,3)=find(Constraints(MultipleConstraints(i),Constrainedby(j),:)>=0); %Identify type of constraint
%         Search4Dominant(j,4)=Constraints(MultipleConstraints(i),Constrainedby(j),Search4Dominant(j,3)); % Constraint Time
%     end
%     
% end
    
    

    

