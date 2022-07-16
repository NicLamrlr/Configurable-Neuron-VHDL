function  full_neuron (wl,fl,fun,sat,neg,pres,serpar,n)

%wl = wordlength
%fl = fraction length
%fun = which activation function:
%   fun = 0 -> LUT
%   fun = 1 -> Taylor
%   fun = 2 -> SONF
%   fun = 3 -> Batch
%sat = activation function saturation
%neg = Take last error subvetor(1 yes - 0 no)
%pres = multiplier precision[3(max), 2(mid), 1(low)]
%serpar = serial or parallel multiplier (1 serial - 0 parallel)
%n = number of inputs
file  = fopen('Neuron_test\data_in_neuron.txt','w');
file2  = fopen('Neuron_test\LUT1_neuron.txt','w');
file3  = fopen('Neuron_test\LUT2_neuron.txt','w');
file4  = fopen('Neuron_test\config_neuron.txt','w');
%file5  = fopen('Neuron_test\weights_data_neuron.txt','w');
file6 = 'Neuron_test\data_out_neuron.txt';


if(sat < 2^(wl-fl-1))
    disp("Saturation must be greater than 2^(wl-fl-1), RESTART");
end


a_max = (-(2^(wl-fl-1))):2^-fl: (2^(wl-fl-1)) - 2^-fl;
a = -sat :2^-fl:(sat - 2^-fl);
b = 0:2^-fl: (sat - 2^-fl);

%Taylor coefs size
cwl = 13;
cfl = 12;
cil = 1;

if(fun ~= 3 )
div = 0;
x12 = 0;
adj2 = 0;
end

fprintf(file4,'%s',"--Multiplier values");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant wordsize: integer := " +wl+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant precision: integer := " +pres+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant neg: integer := " +neg+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant serpar: integer := " +serpar+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"-------------------------------------");
fprintf(file4, '\n');


if(fun ~= 1 )
fprintf(file4,'%s',"--Inner Multiplier values");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant wordsize_inner: integer := " +wl+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant precision_inner: integer := " +pres+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant neg_inner: integer := " +neg+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant serpar_inner: integer := " +serpar+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"-------------------------------------");
fprintf(file4, '\n');
end
fprintf(file4,'%s',"--Neuron values");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant n: integer := " +n+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"type inputs is array (0 to n-1) of unsigned (wordsize - 1 downto 0);");
fprintf(file4, '\n');
fprintf(file4,'%s',"-------------------------------------");
fprintf(file4, '\n');


fprintf(file4,'%s',"--AF values");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant fun: integer := " +fun+ ";");
fprintf(file4, '\n');


fprintf(file4,'%s',"--Taylor values");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant wl: integer := " +wl+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant fl: integer := " +fl+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant il: integer := " +(wl - fl)+ ";");
fprintf(file4, '\n');



fprintf(file4,'%s',"constant cwl: integer := " +cwl+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant cfl: integer := " +cfl+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s',"constant cil: integer := " +cil+ ";");
fprintf(file4, '\n');
fprintf(file4,'%s','constant one_out : std_logic_vector(wl - 1 downto 0) := "');
fprintf(file4,'%s','1');
fprintf(file4,'%s',string(zeros(1,wl - 1)));
fprintf(file4,'%s','";');
fprintf(file4, '\n');

fprintf(file4,'%s',"constant correction : std_logic_vector := " );
fprintf(file4,'%s','"');
fprintf(file4,'%s',string(zeros(1,cwl-wl)));
fprintf(file4,'%s','";');
fprintf(file4, '\n');

fprintf(file4,'%s',"constant lowlimit : signed:= "+ '"' +dec2q(-1.5,(wl-fl-1),fl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');  

fprintf(file4,'%s',"constant highlimit : signed:= "+ '"' +dec2q(1.5,(wl-fl-1),fl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');

fprintf(file4,'%s',"--Taylor coefs midrange <1.12>");
fprintf(file4, '\n');

fprintf(file4,'%s',"constant CT1M : signed(cwl - 1 downto 0):= "+ '"' +dec2q(0.5,0,cfl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');   

fprintf(file4,'%s',"constant CT2M : signed(cwl - 1 downto 0):= " + '"'+dec2q(0.25,0,cfl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');  

fprintf(file4,'%s',"constant CT3M : signed(cwl - 1 downto 0):= " + '"'+dec2q(-0.0208,0,cfl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');  

fprintf(file4,'%s',"constant CT4M : signed(cwl - 1 downto 0):= " + '"'+dec2q(0.0022,0,cfl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');  



fprintf(file4,'%s',"--Taylor coefs sides <1.12>");
fprintf(file4, '\n');

fprintf(file4,'%s',"constant CT1S : signed(cwl - 1 downto 0):= " + '"'+dec2q(0.4382,0,cfl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');   

fprintf(file4,'%s',"constant CT2S : signed(cwl - 1 downto 0):= " + '"'+dec2q(0.3926,0,cfl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');  

fprintf(file4,'%s',"constant CT3S : signed(cwl - 1 downto 0):= " + '"'+dec2q(-0.1086,0,cfl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');  

fprintf(file4,'%s',"constant CT4S : signed(cwl - 1 downto 0):= " + '"'+dec2q(0.0142,0,cfl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');

fprintf(file4,'%s',"constant CT5S : signed(cwl - 1 downto 0):= " + '"'+dec2q(-7.3242e-04,0,cfl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');

fprintf(file4,'%s',"-------------------------------------");
fprintf(file4, '\n');

fprintf(file4,'%s',"--SONF values");
fprintf(file4, '\n');
fprintf(file4,'%s','constant one_in : std_logic_vector(wl - 1 downto 0) := "');
fprintf(file4,'%s',dec2q(1,(wl-fl-1),fl,'bin'));
fprintf(file4,'%s','";');
fprintf(file4, '\n');
fprintf(file4,'%s',"-------------------------------------");
fprintf(file4, '\n');

for i = 1:size(a,2)
    %fprintf(file,'%s',dec2q(a(i),(wl-fl-1),fl,'bin'));
    e(i) = Sigmoid(a(i));
    if i ~= size(a,2)
        %fprintf(file, '\n');
    end
end
for i = 1:size(b,2)
    x(i) = Sigmoid(b(i)); 
end

if(fun == 0) %LUT   
    
    for i = 1:size(x,2)
    x1(i,:) = dec2q(x(i),0,wl - 1,'bin');
    end
    x1(:,1) = [];
    for i = 1:size(x1,1)
        fprintf(file2,'%s',x1(i,:));
        if i ~= size(x1,1)
            fprintf(file2, '\n');
        end
    end
    
    
elseif fun == 1 %Taylor       
    if(wl>12)
        disp("Taylor implementation currently only supports implementations with 12 bits or lower, RESTART");
    end
    fprintf(file4,'%s',"--Inner Multiplier values");
    fprintf(file4, '\n');
    fprintf(file4,'%s',"constant wordsize_inner: integer := " +cwl+ ";");
    fprintf(file4, '\n');
    fprintf(file4,'%s',"constant precision_inner: integer := " +pres+ ";");
    fprintf(file4, '\n');
    fprintf(file4,'%s',"constant neg_inner: integer := " +neg+ ";");
    fprintf(file4, '\n');
    fprintf(file4,'%s',"constant serpar_inner: integer := " +serpar+ ";");
    fprintf(file4, '\n');
    fprintf(file4,'%s',"-------------------------------------");
    fprintf(file4, '\n');
elseif fun == 2 %SONF 
elseif(fun == 3)%BATCH   
    index = 1;
    index2 = 1;
    index3 = 1;
    first = 0;
    diff = 0;
    max = 0;
    saw_index = 0;
    
    prompt = 'Input batch size \n';
    in = input(prompt);
    while(floor(log2(in)) ~= ceil(log2(in)) || in <=1)
        prompt = 'Batch size must be 2^n\n';
        in = input(prompt);
    end
    div = log2(in);
    for i = 1:size(x,2)    
        if(index == 1)
            first = x(i);
            x1(index2,:) = x(i);
            index2 = index2 + 1;
        elseif(index<in)

        elseif(index == in)
            if((x(i) - first) > 2^-(wl) && (x(i) - first) < 2^-(wl-1) && in == 2)
                adj(index3,:) = 2^-(wl-1);
                index3 = index3 + 1;
                index = 0;
            elseif(in == 2 && (x(i) - first) < 2^-(wl))
                adj(index3,:) = 0;
                index3 = index3 + 1;
                index = 0;
            else
                adj(index3,:) = (x(i) - first);
                index3 = index3 + 1;
                index = 0;
            end
        end
        index = index + 1;
    end 
    for i = 1:size(adj,1)
        if(adj(i,:) > max)
            max = adj(i,:);
        end
    end
    
    max = dec2q(max,0,wl - 1,'bin');

    for i = 1:length(max)
        if(max(i) == '1')
            saw_index = i - 1;
            break;
        end
    end
    for i = 1:size(adj,1)
        adj2(i,:) = dec2q(adj(i),0,wl-1,'bin'); 
        x12(i,:) = dec2q(x1(i,:),0,wl-1,'bin');
    end

   adj2(:,1:saw_index) = [];
   x12(:,1) = [];

    for i = 1:size(x12,1)
        fprintf(file2,'%s',x12(i,:));
        fprintf(file3,'%s',adj2(i,:));
        if i ~= size(x1,1)
            fprintf(file2, '\n');
            fprintf(file3, '\n');
        end
    end
end


fprintf(file4,'%s',"--Batch values");
fprintf(file4, '\n');
fprintf(file4,'%s','constant div: std_logic_vector:= "');
fprintf(file4,'%s',string(zeros(1,div)));
fprintf(file4,'%s','";');
fprintf(file4, '\n');

fprintf(file4,'%s',"constant bot: integer := " +div+ ";");
fprintf(file4, '\n');

fprintf(file4,'%s',"constant value_height: integer := " +size(x12,1)+ ";");
fprintf(file4, '\n');

fprintf(file4,'%s',"constant index_height: integer := " +size(adj2,1)+ ";");
fprintf(file4, '\n');

fprintf(file4,'%s',"constant value_width: integer := " +size(x12,2)+ ";");
fprintf(file4, '\n');

fprintf(file4,'%s',"constant index_width: integer := " +size(adj2,2)+ ";");
fprintf(file4, '\n');



% 
% a = -sat;
% b = sat;
% ran = (b-a).*rand(n,1) + a;
% weights = ran;
% index = 1;
% 
% for i = 1:size(ran,1)
%     fprintf(file5,'%s',dec2q(ran(i),(wl-fl-1),fl,'bin'));
%     if i ~= size(ran,1)
%         fprintf(file5, '\n');
%     end
% end
% for j = 1:10
%     a = -sat;
%     b = sat;
%     ran = (b-a).*rand(n,1) + a;
% for i = 1:size(ran,1)
%     data_in(index) = ran(i);
%     index  = index + 1;
%     if(i ~= size(ran,1))
%     fprintf(file,'%s',"d_in("+(i-1)+')<="');
%     fprintf(file,'%s',dec2q(ran(i),(wl-fl-1),fl,'bin'));
%     fprintf(file,'%s','";');
%     fprintf(file, '\n');
%     else
%     fprintf(file,'%s',"d_in("+(i-1)+')<="');
%     fprintf(file,'%s',dec2q(ran(i),(wl-fl-1),fl,'bin'));
%     fprintf(file,'%s','";');
%     fprintf(file, '\n');
%     fprintf(file,'%s',"wait for 10ns;");
%     fprintf(file, '\n');
%     fprintf(file, '\n');
%     fprintf(file, '\n');
%     end
%     
% end
% end

% iw = 1;
% iw2 = 1;
% zz = 0;
% for i = 1:size(data_in,2)
%     if(iw <= n)
%     zz = zz + data_in(i)*weights(iw);
%     iw = iw + 1;
%     else
%       iw = 1;
%       final_res(iw2) = Sigmoid(zz);
%       iw2 = iw2 + 1;
%       zz = data_in(i)*weights(iw); 
%     end
% end
% 
% final_res
disp('Copy config file to package and data_in_neuron to testbench');
pause;

%    text = strsplit(fileread(file6), {'\r', '\n'});
%     out = char(text);
%     
%     
%     
%     out(2,:) = [];
%     out(1,:) = [];    
%     
%     for i = 1:n
%         r(i) = (q2dec(out(i,:),0,wl - 1,'bin'));
%     end
% 
%     
%     
%     plot(final_res - r)
%     max = 0;
%     nerror = 0;
%     errbuff = 0;
%     red = 0;
%     
%     for i = 1:size(e,2)
%         if(abs(e(i)) > max)
%             max  = abs(e(i));
%         end
%         if(r(i) ~= e(i))
%             nerror = nerror + 1;
%             errbuff = errbuff + abs(e(i) - r(i));
%             if(e(i) ~= 0)
%                 red = red + ((abs(e(i) - r(i)))/e(i));
%             else 
%                 red = red + ((abs(e(i) - r(i))));
%             end
%         end
%     end
%     ER = nerror/size(e,2) * 100
%     MED = errbuff/size(e,2)
%     MRED = red/nerror
%     NMED = MED/1

end