require 'rails_helper'

describe TicketPolicy do
  context "permissions" do
    subject { TicketPolicy.new(user, ticket) }

    let(:user) { FactoryGirl.create(:user) }
    let(:project) { FactoryGirl.create(:project) }
    let(:ticket) { FactoryGirl.create(:ticket, project: project) }


    context "for anonymous users" do
      let(:user) { nil }
      it { should_not permit_action :show } 
      it { should_not permit_action :create } 
      it { should_not permit_action :update } 
      it { should_not permit_action :destroy } 
    end

    context "for viewers of projects" do
      before { assign_role!(user, :viewer, project) }
      it { should permit_action :show }
      it { should_not permit_action :create }
      it { should_not permit_action :update } 
      it { should_not permit_action :destroy } 
    end

    context "for editors of projects" do
      before { assign_role!(user, :editor, project) }
      it { should permit_action :show }
      it { should permit_action :create }
      it { should_not permit_action :update }
      it { should_not permit_action :destroy }

      context "when editor created the ticket" do
        before { ticket.author = user }
        it { should permit_action :update }
        it { should_not permit_action :destroy }
      end
    end

    context "for managers of a project" do
      before { assign_role!(user, :manager, project) }

      it { should permit_action :show } 
      it { should permit_action :create }
      it { should permit_action :update }
      it { should permit_action :destroy }    
    end

    context "for managers of other project" do
      before do
        other_project = FactoryGirl.create(:project)
        assign_role!(user, :manager, other_project)
      end 

      it { should_not permit_action :show } 
      it { should_not permit_action :create } 
      it { should_not permit_action :update }
      it { should_not permit_action :destroy }    
    end 

    context "for admins" do
      before do
        user.admin = true
      end 

      it { should permit_action :show }  
      it { should permit_action :create } 
      it { should permit_action :update }
      it { should permit_action :destroy }    
    end 

  end
end
