original=getTitle();
setBatchMode(true);
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=25 stack");
filtered=getTitle();
imageCalculator("Subtract stack", original,filtered);

run("Smooth", "stack");

