phase1 = 0:0.25:0.99;
phase2 = 0:0.25:0.99;
dur = 0.2;

sinfreq = 1;

sampfreq = 50;
cyclesperstim = 10;
precycles = 5;
postcycles = 5;

cyclespersamp = sinfreq / sampfreq;

[p1,p2] = ndgrid(phase1,phase2);

p1 = p1(:);
p2 = p2(:);
dp = p2 - p1;

tprev = precycles/sinfreq;
stimt = zeros(size(p1));
for i = 1:length(p1)
    stimdur = (cyclesperstim + p1(i) + (1 - p2(i))) / sinfreq;
    
    stimt(i) = tprev;
    tprev = tprev + stimdur;
end

totaldur = tprev + postcycles/sinfreq;

t = 0:1/sampfreq:totaldur;
phase = t * sinfreq;

dphase = zeros(size(t));
for i = 1:length(p1)
    ind = (stimt(i) + p1(i)/sinfreq) * sampfreq + 1;
    dphase(round(ind)) = dp(i);
end

cumdphase = [0 cumsum(dphase)];
cumdphase = cumdphase(1:end-1);

phase = phase + cumdphase;

stimphase = zeros(size(t));
for i = 1:length(stimt)-1
    stimcycles = (stimt(i+1) - stimt(i)) * sinfreq;
    
    ind = round(stimt(i) * sampfreq)+1;

    stimphase1 = 0:cyclespersamp:stimcycles;
    stimphase1 = stimphase1 - 1 + dp(i);
    
    stimphase(ind+(0:length(stimphase1)-1)) = stimphase1;
end


