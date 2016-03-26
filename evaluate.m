function [faces,cars,motorbikes, airplanes] = evaluate(classes,words, k, ...
            colorSpace, faces_svm, cars_svm, motorbikes_svm, airplanes_svm)

    ts = tic;
    
    fprintf(' evaluating ... ');
    faces = struct;
    cars= struct;
    motorbikes = struct;
    airplanes = struct;
    for ci = 1:4
        filePath=importdata(sprintf('Caltech4/ImageSets/%s_test.txt',char(classes(ci))));
        testD = zeros(50,k);
        for imi = 1:50
            D = getDescriptors(char(classes(ci)),'test',imi,colorSpace);
            testD(imi,:) = getXdata(D,words);
        end
        range = (ci-1)*50+1:ci*50;
        
        [labels,scores] =  predict(faces_svm,testD);
        faces.labels(range) = labels;
        faces.scores(range) = scores(:,2);
        faces.fns(range) = filePath';
        [labels,scores] = predict(cars_svm,testD);
        cars.labels(range) = labels;
        cars.scores(range) = scores(:,2);
        cars.fns(range) = filePath';
        [labels,scores] = predict(motorbikes_svm,testD);
        motorbikes.labels(range) = labels;
        motorbikes.scores(range) = scores(:,2);
        motorbikes.fns(range) = filePath';
        [labels,scores] = predict(airplanes_svm,testD);
        airplanes.labels(range) = labels;
        airplanes.scores(range) = scores(:,2);
        airplanes.fns(range) = filePath';
    end
    toc(ts);
    
    
    faces.reals = [ones(50,1);-1*ones(150,1)];
    [~,order] = sort(faces.scores,1,'descend');
    faces.fns = faces.fns(order);
    faces.labels = faces.labels(order);
    faces.scores = faces.scores(order);
    faces.reals = faces.reals(order);
    
    cars.reals = [-1*ones(50,1);ones(50,1);-1*ones(100,1)];
    [~,order] = sort(cars.scores,1,'descend');
    cars.fns = cars.fns(order);
    cars.labels = cars.labels(order);
    cars.scores = cars.scores(order);
    cars.reals = cars.reals(order);
    
    motorbikes.reals = [-1*ones(100,1);ones(50,1);-1*ones(50,1)];
    [~,order] = sort(motorbikes.scores,1,'descend');
    motorbikes.fns = motorbikes.fns(order);
    motorbikes.labels = motorbikes.labels(order);
    motorbikes.scores = motorbikes.scores(order);
    motorbikes.reals = motorbikes.reals(order);
    
    airplanes.reals = [-1*ones(150,1);ones(50,1)];
    [~,order] = sort(airplanes.scores,1,'descend');
    airplanes.fns = airplanes.fns(order);
    airplanes.labels = airplanes.labels(order);
    airplanes.scores = airplanes.scores(order);
    airplanes.reals = airplanes.reals(order);
    
end
