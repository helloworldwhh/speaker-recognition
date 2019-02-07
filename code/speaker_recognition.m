%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                   
%本代码适用于单人的说话人确认                                                       
clc;                                                                                
clear all;                                                                          
close all;                                                                          
MFCC_size=12;%mfcc的维数                                                            
GMMM_component=16;%GMM component 个数                                                                                                                      
mu_model=zeros(MFCC_size,GMMM_component);%高斯模型 分量 均值                        
sigma_model=zeros(MFCC_size,GMMM_component);%高斯模型 分量 方差                     
weight_model=zeros(GMMM_component);%高斯模型 分量 权重                              
file=['N';'F';'S'];                                                                                
train_file_path='E:\Desktop\数字视音频处理\音频\316010***-录音\316010****-W1\';%模型训练文件路径                                 
num_train=6;%目标说话人模型训练文件的个数                                           
test_file_path='E:\Desktop\数字视音频处理\音频\316010***-录音\316010****-W15\';%测试文件路径

num_test=2;%测试情况下朗读的次数                                                    
num_uttenance=18;%测试情况下每次朗读的句子的总数                                    
all_train_feature=[];                                                               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                    
%train model                                                                        
%使用1_1～1_6训练                                                                   
for i=1:num_train                                                                   
    train_file=[train_file_path 'N' num2str(i) '.wav'];    
    [wav_data ,fs]=audioread(train_file);                                             
    train_feature=melcepst(wav_data ,fs);                                           
    all_train_feature=[all_train_feature;train_feature];                            
end                                                                                 
[mu_model,sigma_model,weight_model]=gmm_estimate(all_train_feature',GMMM_component);
                                                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                    
%test                                                                               
                                                                   
for i=1:3     
    for j=1:6
        test_file=[test_file_path file(i) num2str(j) '.wav'];                
        [wav_data ,fs]=audioread(test_file);                                          
        test_feature=melcepst(wav_data ,fs);                                        
        [lYM, lY] = lmultigauss(test_feature', mu_model, sigma_model, weight_model);
        score((i-1)*6+j) = mean(lY);                                                        
        fprintf('Test：%s_%d  score:%f\n',file(i),j,score((i-1)*6+j)); 
    end
end                                                                             
                                                                             
                                                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                      
%result                                                                             
[max_score,max_id]=max(score);                                                      
[min_score,min_id]=min(score);                                                      
fprintf('Max score:%f\nMin score:%f\n',max_score,min_score);
fprintf('Max-id:%d\nMin-id:%d\n',max_id,min_id);
