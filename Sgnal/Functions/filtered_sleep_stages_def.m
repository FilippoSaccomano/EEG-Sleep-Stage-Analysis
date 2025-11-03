function sleep_stage_filtered = filtered_sleep_stages_def(sleep_stage, min_duration)


for i=1:(min_duration):(length(sleep_stage)-min_duration)

    m=round(median(sleep_stage(i:i+min_duration-1)));
    sleep_stage_filtered(i:i+min_duration-1)=m;
end
