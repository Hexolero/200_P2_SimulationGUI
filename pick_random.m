function F = pick_random(P, X)
%PICK_RANDOM Summary of this function goes here
% Given two arrays P and X, where P(i) is the probability to pick X(i),
% pick a random variable from array X.
F = X(find(rand < cumsum(P), 1, 'first'));
end

