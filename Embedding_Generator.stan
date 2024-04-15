data {
  int<lower=0> N;
  int<lower=0> T;

  real gp_theta_mu_pr;
  real gp_theta_sigma_pr;
  
  real gp_sigma_mu_pr;
  real gp_sigma_sigma_pr;

  real gp_m_mu_pr;
  real gp_m_sigma_pr;
  
  real psi_pr;

}

parameters {
  real gp_theta;
  real<lower=0> gp_sigma;
  real<lower=0,upper=1> gp_m;
  
  vector<lower=0>[N] psi;
  vector[N] subj_theta;

}

transformed parameters {
    vector[N] psi_st;
    psi_st = (psi - mean(psi)) / sd(psi);

}

model {
    gp_theta ~ normal(gp_theta_mu_pr,gp_theta_sigma_pr);
    gp_sigma ~ normal(gp_sigma_mu_pr,gp_sigma_sigma_pr);
    gp_m ~ normal(gp_m_mu_pr,gp_m_sigma_pr);
    
    psi ~ exponential(psi_pr); 

    
        for (n in 1:N){
        subj_theta[n] ~ normal(gp_theta + gp_m * psi_st[n], gp_sigma);
        }

}

generated quantities{
  array[N,T] int y_pred;
  vector[N] psi_pred;

             for(n in 1:N){
        psi_pred[n] = exponential_rng(psi_pr);
        
      for (t in 1:T){
        y_pred[n,t] = bernoulli_logit_rng(subj_theta[n]);
      }
             }
        psi_pred = (psi_pred - mean(psi_pred)) / sd(psi_pred);
    }


