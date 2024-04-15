data {
  int<lower=0> N;
  int<lower=0> T;
  array[N,T] int y;

  real gp_theta_mu_pr;
  real gp_theta_sigma_pr;
  
  real gp_sigma_mu_pr;
  real gp_sigma_sigma_pr;

  real gp_m_mu_pr;
  real gp_m_sigma_pr;
  
  vector[N] psi_y;
}

parameters {
  real gp_theta;
  real<lower=0> gp_sigma;
  real<lower=0,upper=1> gp_m;

  vector[N] subj_theta;

}

model{
    gp_theta ~ normal(gp_theta_mu_pr,gp_theta_sigma_pr);
    gp_sigma ~ normal(gp_sigma_mu_pr,gp_sigma_sigma_pr);
    gp_m ~ normal(gp_m_mu_pr,gp_m_sigma_pr);
    
        for (n in 1:N){
          subj_theta[n] ~ normal(gp_theta + gp_m * psi_y[n], gp_sigma);
        for (t in 1:T){
        y[n,t] ~ bernoulli_logit(subj_theta[n]);
}
}
}

generated quantities{
  array[N,T] int y_pred;
  array[N,T] real log_lik;
  
          
      for (n in 1:N){

      for (t in 1:T){
        y_pred[n,t] = bernoulli_logit_rng(subj_theta[n]);
        
        log_lik[n,t] = bernoulli_logit_lpmf(y[n,t] | subj_theta[n]);
       
}
}
}