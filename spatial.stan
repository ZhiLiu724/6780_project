data {
  int<lower=0> N;          // number of incidents 
  vector[2] x[N];               // (latitude, longitude) pair
}
parameters {
  real mu[2]; 
  real<lower=0> tau;
  vector[J] eta;
}
transformed parameters {
  vector[J] theta;
  theta = mu + tau * eta;
}
model {
  target += normal_lpdf(eta | 0, 1);
  target += normal_lpdf(y | theta, sigma);
}