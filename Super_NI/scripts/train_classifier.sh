#!/bin/bash
gpu=$1
batch=$2
model=$3
train_mix_gen=$4  # 0 or 1
lr=$5

set -x

echo "export CUDA_VISIBLE_DEVICES=$gpu"

export CUDA_VISIBLE_DEVICES=${gpu}
export CUDA_DEVICE_ORDER="PCI_BUS_ID"
export TRANSFORMERS_CACHE=/aul/homes/hzhen011/Text-to-Text-Classification/Super_NI/scratch/rml6079/.cache/huggingface
export CUDA_LAUNCH_BLOCKING="1"

port=$(shuf -i25000-30000 -n1)

# convert train_mix_gen to boolean
if [ "$train_mix_gen" -eq 1 ]; then
  train_mix_gen=true
elif [ "$train_mix_gen" -eq 0 ]; then
  train_mix_gen=false
else
  echo "Invalid train_mix_gen, set to False as default"
  train_mix_gen=false
fi

data_dir=data/splits/default
task_dir=data/tasks/add_output_space
output_dir=output_classifier/${model}-mix_gen_${train_mix_gen}
Tk_instruct_cache_dir=/aul/homes/hzhen011/Text-to-Text-Classification/Super_NI/scratch/rml6079/project/Tk-Instruct/cache/
lr_proj=3e-3

python src/run_classifier.py \
    --do_train \
    --do_predict \
    --predict_with_generate \
    --model_name_or_path ${model} \
    --max_source_length 1024 \
    --max_target_length 128 \
    --generation_max_length 128 \
    --max_num_instances_per_task 100 \
    --max_num_instances_per_eval_task 100 \
    --add_task_name False \
    --add_task_definition True \
    --num_pos_examples 0 \
    --num_neg_examples 0 \
    --add_explanation False \
    --tk_instruct False \
    --data_dir ${data_dir} \
    --task_dir ${task_dir} \
    --output_dir ${output_dir} \
    --overwrite_output_dir \
    --cache_dir ${Tk_instruct_cache_dir} \
    --overwrite_cache \
    --per_device_train_batch_size ${batch} \
    --per_device_eval_batch_size ${batch} \
    --gradient_accumulation_steps 2 \
    --learning_rate ${lr} \
    --num_train_epochs 2 \
    --lr_scheduler_type constant \
    --warmup_steps 0 \
    --logging_strategy steps \
    --logging_steps 500 \
    --evaluation_strategy epoch \
    --save_strategy no \
    --save_steps 2500 \
    --bf16 \
    --run_name train_classifier-mix_gen_${train_mix_gen} \
    --seed 42 \
    --train_mix_gen ${train_mix_gen} \
    --classifier_dropout 0.2 \
    --learning_rate_proj ${lr_proj}
