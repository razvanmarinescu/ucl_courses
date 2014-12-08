function prob91()

import brml.*

load('printer.mat')

[nr_nodes, nr_visits] = size(x);
x = x-ones(nr_nodes, nr_visits);

[fuse drum toner paper roller burn quality wrinkled mult jam] = assign(1:nr_nodes);

pots = cell(nr_nodes,1);

% define the dependencies for each node.
deps = cell(nr_nodes,1);
deps{fuse} = [];
deps{drum} = [];
deps{toner} = [];
deps{paper} = [];
deps{roller} = [];
deps{burn} = [fuse];
deps{quality} = [drum, toner, paper];
deps{wrinkled} = [fuse, paper];
deps{mult} = [paper, roller];
deps{jam} = [fuse, roller];

for node=1:nr_nodes
    % filter x 
    parents = deps{node};
    nr_parents = length(parents);
    if nr_parents > 0
        potTable = zeros(2 * ones(1,nr_parents+1));
        for state=0:2^nr_parents - 1
            binState = binary2vector(state,nr_parents);
            indicesToKeep = ones(1, nr_visits);
            for pI=1:nr_parents
                parent = parents(pI);
                indicesToKeep = indicesToKeep .* (x(parent,:) == binState(pI));
            end 
            % convert from binary to decimal and filter non-zero values
            indicesToKeep = indicesToKeep .* [1:nr_visits];
            new_x = x(:,indicesToKeep(indicesToKeep > 0));
            
            if(nr_parents == 1)
                potTable(:,binState(1)+1) = getPot(new_x, node)';
            end
            if(nr_parents == 2)
                potTable(:,binState(1)+1,binState(2)+1) = getPot(new_x, node);
            end
            if(nr_parents == 3)
                potTable(:,binState(1)+1,binState(2)+1,binState(3)+1) = getPot(new_x, node);
            end
            endq
        pots{node} = array([node parents], potTable); 
    end
    
    if nr_parents == 0
        pots{node} = array([node], getPot(x, node));
    end
end

% compute joint probability
joint = pots{1};
for node=2:nr_nodes
    joint = multpots([joint pots{node}]);
end

% compute the posterior of the problems on the faults
joint

jointFuse = sumpot(joint, [drum toner paper roller])

posterior = condpot(joint, [fuse], [burn quality wrinkled mult jam])

no = 1;
yes = 2;
fuseState = yes;
burnState = yes;
qualityState = no; 
wrinkledState = no;
multState = no;
jamState = yes;

posterior.table(fuseState, burnState, qualityState, wrinkledState, multState, jamState)

end

function pot = getPot(x, node)
[~, nr_visits_filtered] = size(x);
pot = [nr_visits_filtered - sum(x(node,:)) sum(x(node,:))];
pot = pot ./ sum(pot);
end

function out = binary2vector(data,nBits)

powOf2 = 2.^[0:nBits-1];

%# do a tiny bit of error-checking
if data > sum(powOf2)
   error('not enough bits to represent the data')
end

out = false(1,nBits);
ct = nBits;

while data>0
if data >= powOf2(ct)
data = data-powOf2(ct);
out(ct) = true;
end
ct = ct - 1;
end

end
