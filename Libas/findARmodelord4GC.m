function [modelorder] = findARmodelord4GC(datamat, maxorder)

[n_chs npts ] = size(datamat);

ntrls = 1

model_order = 1:maxorder; 

temp_data = diff(datamat')'

        for p=1:length(model_order)
            
            current_model_order=model_order(p);
                            
            disp(['FITTING AR MODEL.............................................']);
            [ar_A,ar_Z] = armorf(temp_data,ntrls,npts,current_model_order); %fitting a model on every possible pair
            
            disp(['CALCULATING AIC BIC.............................................']);
            AIC_mat(current_pair_n,p)=log(abs(det(ar_Z)));
            AIC_second_half(current_pair_n,p)=(2*current_model_order*2^2)/(npts*10);
            
            AIC(current_pair_n,p)=AIC_first_half(current_pair_n,p)+AIC_second_half(current_pair_n,p);
            
            BIC_first_half(current_pair_n,p)=log(abs(det(ar_Z)));
            BIC_second_half(current_pair_n,p)=((2*current_model_order*2^2)/(npts*10))*log(npts*10);
            
            BIC(current_pair_n,p)=BIC_first_half(current_pair_n,p)+BIC_second_half(current_pair_n,p);
        
        end
        
              
  


