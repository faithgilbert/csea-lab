function data=plot_curve(filename);file1 = fopen(filename);data = fscanf(file1, '%f', [2 inf]);fclose(file1);plot(data(1,:), data(2,:));title(filename);