//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

data {
  int<lower = 0> N_obs;
  int<lower = 0> N_Borough;
  //int<lower = 0> N_Census;
  int<lower = 0> N_Category;
  int<lower = 0> N_Month;
  
  matrix[N_obs, N_Borough] X_Borough;
  //matrix[N_Census, N_Borough] census_to_borough;
  //matrix[N_obs, N_Census] X_Census;
  matrix[N_obs, N_Category] X_Category;
  matrix[N_obs, N_Month] X_Month;
  
  int<lower = 0> Y[N_obs];
  real offset[N_obs];
  //int<lower = 0, upper = 1> use_hierarchy;
  int<lower = 0, upper = 1> use_month;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  vector[N_Borough] beta_Borough;
  //vector[N_Census] beta_Census;
  vector[N_Category] beta_Category;
  vector[N_Month] beta_Month;

}


transformed parameters{
  real log_mu[N_obs]; // log mean, for calculation
  real<lower = 0> mu[N_obs]; // the mean of the poisson random variable
  //real census_mean[N_Census];

  for (i in 1:N_obs) {
    log_mu[i] = offset[i];
    log_mu[i] += dot_product(X_Borough[i], beta_Borough);
    //log_mu[i] += dot_product(X_Census[i], beta_Census);
    log_mu[i] += dot_product(X_Category[i], beta_Category);
    if (use_month == 1){
      log_mu[i] += dot_product(X_Month[i], beta_Month);
      };
  };
  
  // log_mu = offset + X_Borough*beta_Borough + X_Census*offset_Census + X_Category*beta_Category + X_Month*beta_Month;
  // cannot make the above expression work, though it should be much more efficient
  
  mu = exp(log_mu);
  
  // Calculate the hierarchical mean for each tract
  //for (i in 1:N_Census){
    //census_mean[i] = dot_product(census_to_borough[i],beta_Borough);
  //}
}

model {
  beta_Borough ~ normal(-1,10);
  //beta_Census ~ normal(-1, 10);
  //beta_Category ~ normal(-1,10);
  //beta_Month ~ normal(0,10);
  Y ~ poisson(mu);
}

