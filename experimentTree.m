function experimentTree(objH,experimentObj)
objH = figure;
TreePosition = [5 5 300 300];

% <1x1 com.mathworks.hg.peer.UITreePeer>
M_treeH = com.mathworks.hg.peer.UITreePeer;
M_treeH.setRoot([]);  %[JS] Remove default JTree->colors/sports/food

%<1x1 javahandle_withcallbacks.com.mathworks.hg.peer.UITreePeer>
TreeH = javacomponent(M_treeH, TreePosition, objH);
set(TreeH, ...
    'Visible',                  1, ...  %[JS] 0 or 1
    'MultipleSelectionEnabled', 1, ...
    'NodeWillExpandCallback',   {@nodeWillExpandFcn, objH}, ...
    'NodeExpandedCallback',     {@nodeExpandedFcn,   objH}, ...
    'NodeSelectedCallback',     {@nodeSelectedFcn,   objH});

%set some nodes and add them to the root node
myRoot = uitreenode('v0', 0, experimentObj.name, [], false);

%add all the conditions to the root of the tree
for i=1:experimentObj.conditionSize
    Node(i) = uitreenode('v0', 10, experimentObj.condition(i).name, [], false);
    myRoot.add(Node(i));
    
    %add all the trials to the condition node
    conditionTrials = experimentObj.condition(i).trials;
    
    for k=1:size(conditionTrials)
        trialNodes(i,k) = uitreenode('v0',20,conditionTrials(i).name,[],false);
        Node(i).add(trialNodes(i,k));
    end
end

%set the tree and expand myRoot node
TreeH.setRoot(myRoot);
TreeH.expand(myRoot);
end

function nodeWillExpandFcn(TreeH, EventData, objH)

EventNodeH = EventData.getCurrentNode;
if TreeH.isLoaded(EventNodeH)
    NodeUD = get(EventNodeH, 'UserData');
end

% Simulates a dynamic number (between 1 and 5) of ferrari owners.
% Each owner has a random name of 10 letters.
% Data from owners could be retreived from database in this callback.
% For small number of childnodes a simple way of updating info is to
% remove all children and add them all again. Maybe not efficient but
% it works.
if EventData.getCurrentNode.getValue == 20
    EventNodeH.removeAllChildren;
    nNodes = 1 + round(4*rand);
    for i=1:nNodes
        Value = 20 + i;
        Name = char(round(97 + 25*rand(1,10))); %random name
        NodeTmp = uitreenode('v0', Value, Name, [], true);
        EventNodeH.add(NodeTmp);
    end
end
TreeH.reloadNode(EventNodeH); %was the way I found to draw changes
end

function nodeSelectedFcn(TreeH, EventData, objH)
EventNodeH = EventData.getCurrentNode;
    NodeName = get(EventNodeH, 'Name');
    NodeValue = get(EventNode,'Value');
    
    % if a trial has been selected update the gui to display the
    % trialframes and trail stimuli
    if(NodeValue == 20)
    
end

function nodeExpandedFcn(TreeH, EventData, objH)
%this is currently a stub
end


