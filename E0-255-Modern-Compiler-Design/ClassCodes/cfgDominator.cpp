#include <bits/stdc++.h>
using namespace std;

vector<set<int>> findDominators(int numNodes, int startNode, const vector<vector<int>> &edges){
    // Building Graph Structure
    set<int> nodes; 
    for(int node=0;node<numNodes;node++) nodes.insert(node);

    vector<set<int>> dominators(numNodes);
    vector<vector<int>> predecessor(numNodes);

    for(auto &edge: edges){
        int u = edge[0], v = edge[1];
        predecessor[v].push_back(u);
    }

    // Assume each node(except startNode) dominates very other node
    for(int node = 0; node < numNodes; node++){
        if(node == startNode) dominators[node] = {startNode};
        else dominators[node] = nodes;
    }

    // while modifiactions to dom
    bool changes = true;
    while(changes){
        changes = false;

        for(int currNode = 0; currNode < numNodes; currNode++){
            if(currNode == startNode) continue;

            // Calculating the Intersection of dominator of predecessor node of currNode
            set<int> IN;
            bool firstElement = true;
            for(int p: predecessor[currNode]){
                if(firstElement){
                    IN = dominators[p];
                    firstElement = false;
                }
                else{
                    set<int> tempIN;
                    set_intersection(
                        IN.begin(), IN.end(),
                        dominators[p].begin(), dominators[p].end(),
                        inserter(tempIN, tempIN.begin())
                    );

                    IN = tempIN;
                }
            }

            IN.insert(currNode); // Union

            // Updating Dominators
            if(IN != dominators[currNode]){
                dominators[currNode] = IN;
                changes = true;
            }
        }
    }

    return dominators;
}

int main() {
    const int numNodes = 9, startNode = 0;
    vector<vector<int>> edges = {{0,1}, {1,2}, {2,3}, {2,4}, {3,5}, {3,6}, {5,7}, {6,7}, {7,2}, {4,8}};

    vector<set<int>> dominators = findDominators(numNodes, startNode, edges);

    int node = 0;
    for(auto &s: dominators){
        cout << "Dominators of " << node++ << ": ";
        for(int d: s) cout << d << ", ";
        cout << "\n";
    }

    return 0;
}